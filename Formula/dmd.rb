class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.078.3.tar.gz"
    sha256 "c5aed2af99bf2d346cf5664151a2c7d06b4e95e4db6663ab6d7952f9a12afc88"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.078.3.tar.gz"
      sha256 "7a6cef7a42f4f46031705d4c7546eb309718ae3e946a45f47de4624236420c83"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.078.3.tar.gz"
      sha256 "282b3f252d98ccede0a50e10c8c301e2ab2bf679648d3d02243625bce3314ceb"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.078.3.tar.gz"
      sha256 "fed25d35548a10959eaf8a26df1c2a11be51c6283e26a02a199b1725d276dcfa"
    end
  end

  bottle do
    sha256 "89653ba1ad4be6588f9e818e5c79f496044edd94181ef9b1e0abff1402510470" => :high_sierra
    sha256 "b9d15cdc2da3c0fb7c954a1be4f3ab435f8e133f31021b0eb510a047d24d3d2b" => :sierra
    sha256 "a6a713ae25fbb55aac9326b8b344e446cc880c61a5ce9e36434f0757eec5a445" => :el_capitan
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
