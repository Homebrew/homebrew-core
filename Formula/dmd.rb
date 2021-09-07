class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.097.2.tar.gz"
    sha256 "10e8fc9b99864bf68f384ca85f0c527221478be08d331ac477a90a2d83b71f4f"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.097.2.tar.gz"
      sha256 "ee09d6e37887bba856c767b9aa36f61b290f2cfe0c470eb4a9ccd7f2e24d4bcd"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.097.2.tar.gz"
      sha256 "3f407f94d5d50a43498acf7f463f56a96f66534901068f8d6be850a1bd12135c"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.097.2.tar.gz"
      sha256 "b04c7ebd16fa1b48aea4667f3906fdb62b4ff94c661eb216ba477f3310faf882"
    end
  end

  bottle do
    sha256 big_sur:      "3d9352cd4ce2ed8874c9da854540a6c3928b3bc81b77788c7e8a09c8580bfbe0"
    sha256 catalina:     "c9fb6b53f38ca780febac7c9d343928a9a2e88bec7aa5a6b7a05b70949915ca2"
    sha256 mojave:       "9ccdddbfac184379c83150a87c2e230863c51866dd099ad9609c4eb22cf4f107"
    sha256 x86_64_linux: "4fe16fa1889fe81062e0484eca751883c06ebea11c0df177f2b9b6fc8a3a24d8"
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

    if OS.mac?
      bin.install "generated/osx/release/64/dmd"
    else
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
