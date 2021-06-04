class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.096.1.tar.gz"
    sha256 "5f20a01739411d693d1cea092dc14e4d022048fe7a0ba787e4682d319f025cd5"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.096.1.tar.gz"
      sha256 "08fe19b949fcf368a052294f92b8128cd1a2157d633273c19a0d843dd1b2223e"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.096.1.tar.gz"
      sha256 "7ca3909a10d06e01d063c6da9aadbeab5e47c168878669dcd5e9997257f2733a"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.096.1.tar.gz"
      sha256 "00bda5c8ac2eda67933f7bbfb1b5aa22b64afa646483eb436c9983d166ddb679"
    end
  end

  bottle do
    sha256 big_sur:  "a69862b78ab828f5339a5c12841bad47ae4266e2abba8fe03e4af618295cd555"
    sha256 catalina: "cd0e6df75c5ed352d99f443d4d90554971abbc882db4b0bd7ddf46c5b4d02b18"
    sha256 mojave:   "9a1deb1735ba1301680e04485ac3727256bfd494fc2d3cc19b8a8719931b0038"
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
