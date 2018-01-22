class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.078.1.tar.gz"
    sha256 "b2575d73c7a941bd8222e7072cf7ee249ea302e36332433211a6d85d09bb3fff"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.078.1.tar.gz"
      sha256 "db64c428d748fd96eada847d501b2df0d2f18d1efa66d1dcd8bc10415baa3123"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.078.1.tar.gz"
      sha256 "e34b7ea1f8b9e897888c1f4747053db1bfc926e466d74086e05409d03092e84d"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.078.1.tar.gz"
      sha256 "2c28db505dfec60fc844a4fa7424c2d32d0e5c75b30972ff4ff2bf8ffb10bca8"
    end
  end

  bottle do
    sha256 "373d098ca25d0e80f828d129516f57a9fca89db99e9315f4e99ce34c2f8e04de" => :high_sierra
    sha256 "78cc3c58b3e4eb2f3fcccff2d74a7198cf3a9825d5ae22d566114c2f017001f0" => :sierra
    sha256 "3f3644c3c07cdb167616a337fdb87958b3c4a8fb62070dcaab078bf75f5349e7" => :el_capitan
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
