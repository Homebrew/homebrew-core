class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.084.1.tar.gz"
    sha256 "95de47ca49db64553e454c28f9037b1132a0587b8ee184facf0575031ee15524"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.084.1.tar.gz"
      sha256 "fde74b40f62892e09eb338a89d0c108ae01a15748c84c4e8cf4894a161697b8d"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.084.1.tar.gz"
      sha256 "1bf230ee27acb04da0614031ce783ddaa4a4b06da3a75b8b279e6a5b1788ca27"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.084.1.tar.gz"
      sha256 "58f12a51e29f97f5a75ec83d2867c4511e80ed6be0ae71ed78b4a23745f8ca2b"
    end
  end

  bottle do
    sha256 "316092a9a666807ee556e5a7bb875b5513781839230660c6ee5db8ec64a11875" => :mojave
    sha256 "418371f9db99797409094c09fd23559a58f3ee5a9e152eb5bfc22a3a55a5d45f" => :high_sierra
    sha256 "579e87a7ab5ce58a870f3f5e311124414f185e0f307bac278bd999221ed1660c" => :sierra
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
    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      -f posix.mak
    ]

    dmd_make_args = %W[
      SYSCONFDIR=#{etc}
      TARGET_CPU=X86
      AUTO_BOOTSTRAP=1
      ENABLE_RELEASE=1
    ]

    system "make", *dmd_make_args, *make_args

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
