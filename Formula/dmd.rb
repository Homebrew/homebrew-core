class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.079.1.tar.gz"
    sha256 "86f125bcc9d1c3d47ed9211b033ebbb38f827a9d37466aa1d91cc1d76b2bb1e8"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.079.1.tar.gz"
      sha256 "9e943fbf38912ef8f71dd7252c0ca2284a23681c8e61a6ee38b317232b676792"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.079.1.tar.gz"
      sha256 "a8585ef4bbd19d02fab4054619324126985db4fdf4d4751a91bd2e6fb23b5fe9"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.079.1.tar.gz"
      sha256 "37e04b77a0ff5e13350662945327dccba4bcd4975d45b61db2524eadad3d56fe"
    end
  end

  bottle do
    sha256 "806f580107fd5d3984d77c186408d8c1f244571f40e59e6bc699eb6e5977e1b7" => :high_sierra
    sha256 "34e236cd3c59bc213a497d822642cd32023b2eaa95c31daab2d90073eb158830" => :sierra
    sha256 "4fb028165c2f6afb94b1c930f31069b8607e74344d74dbdc1e5e84580fd5a7e9" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.080.0-beta.1.tar.gz"
    sha256 "a3ec6f5fe3705555263920299e5464e024892c7ad037b89f90b375cc97635dfa"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.080.0-beta.1.tar.gz"
      sha256 "3ce24d7fb91575c0ffc88c84dd36f0de3782c5d9f1753b2a8a14c2c38eafbb25"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.080.0-beta.1.tar.gz"
      sha256 "e2a989a424f4f571eee0f59b6b6f5bf438c15c28d7e18b1e127225e6666b9c3f"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.080.0-beta.1.tar.gz"
      sha256 "f11f5849e350f8241865fefd026249b0eb036949e258d83254ff70449d99036a"
    end
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"

    (buildpath/"druntime").install resource("druntime")
    system "make", "-C", "druntime", *make_args

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    bin.install "generated/osx/release/64/dmd"
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
