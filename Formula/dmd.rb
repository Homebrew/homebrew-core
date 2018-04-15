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
    sha256 "97d03f87d565f4de54115979f93caf06bb6f5efc1eee9b85abb91b1e9a935620" => :high_sierra
    sha256 "f794c009e4f0ad7bac0d02d95d26c4008c773c0412fe981eafb3cfdf9e983d36" => :sierra
    sha256 "5df9aba344c92105b0d08ce5b6535778ea1ec28eddc6ede4ebf4c84ede0fa38a" => :el_capitan
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
