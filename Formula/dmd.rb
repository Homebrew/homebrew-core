class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.096.0.tar.gz"
    sha256 "5f0037b87b7da6778e9463b4b00de3cbd08b2c3b52ecc6503eed9b2a2e388e96"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.096.0.tar.gz"
      sha256 "7e20f53dd98454eaa97d9629759ceccd150bf48726bb38f13f1821f55e867672"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.096.0.tar.gz"
      sha256 "72e1641f369431cbd63762619de10d1eca386eaa1e9a4bf3a959080dd05d7f84"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.096.0.tar.gz"
      sha256 "8eb61278746c381e746f9eabbd36eba2d2fec761e341a47999855a4a24467a46"
    end
  end

  bottle do
    sha256 big_sur:  "0c7fbdf3cd08b39f8b4b930483c0873f39db7e45b7ecbb003bb89b38b208f0ac"
    sha256 catalina: "d3ff6f70a572e29933b12c8354856c1edbc8c3316527a29f3c238b71454c52e1"
    sha256 mojave:   "ec9279e77c4783583a0d2afc8667d373808db62535aabf32364b10067519fb3b"
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

  depends_on arch: :x86_64

  uses_from_macos "unzip" => :build
  uses_from_macos "xz" => :build

  def install
    # DMD defaults to v2.088.0 to bootstrap as of DMD 2.090.0
    # On MacOS Catalina, a version < 2.087.1 would not work due to TLS related symbols missing

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

    on_macos do
      bin.install "generated/osx/release/64/dmd"
    end
    on_linux do
      bin.install "generated/linux/release/64/dmd"
    end
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]

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
