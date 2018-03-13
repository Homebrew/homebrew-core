class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.079.0.tar.gz"
    sha256 "e4fed191a05051dd262198ebbfd77e9e99fbad251b67b88b3394e2cca8a41893"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.079.0.tar.gz"
      sha256 "531910210e29c938ecee8ff6f39d2d247e892cae71811a684a504504bf1ea29b"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.079.0.tar.gz"
      sha256 "39cae5b9578925a9458654c64c9a85204b7598c685c2e48b7d4fcfc37d4a3550"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.079.0.tar.gz"
      sha256 "84598250c08ce1bdb9836a652c8ae09d8a5c429e60466b64df6c28fc9a24e684"
    end
  end

  bottle do
    sha256 "3e4f2f2407c37d616971d6fa53856f43557845670b5e258d34cee67d3a2898df" => :high_sierra
    sha256 "667b441c4fd254982cb7cb97e29562dfdf997c5350ac22ba2ef33c6a98cce8e2" => :sierra
    sha256 "48175fa13ebd0794ead40194c83cb30f9bc78db92dc1e6e2e00ff9207d1591ca" => :el_capitan
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
