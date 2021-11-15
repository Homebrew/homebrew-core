class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.098.0.tar.gz"
    sha256 "437e7abae7f747ce8a027e512d2f98f0c27badd623347141c3f6fb0834d85ad0"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.098.0.tar.gz"
      sha256 "f150400756c7940bc9d67a3ed7f89777e49b42a1ef2dff6f40727f83b3cea6f4"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.098.0.tar.gz"
      sha256 "f91c6c7f2d5683af2804a183c287bf6991b99c49692759d7844e1919ca59e974"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.098.0.tar.gz"
      sha256 "9466e62ed2cf80802158524fc4e7ff80cbefc0fadff23a8933f6f2892b42cb56"
    end
  end

  bottle do
    sha256 monterey:     "8618eddb935558875b1c57bbf023334c6767b27d7e915bcfa07f38a91e2cdc47"
    sha256 big_sur:      "b2c95835a1295b25169b3e96eacfddc479cd24efc6d58285e42a1436c2b097ce"
    sha256 catalina:     "ec5dec4305424b179a815a4d15a8f85591bfb73d5cc92ca34b4ada0f05c34743"
    sha256 mojave:       "82a178b02a4001d6a7f0e466d33bc6479be456b27bd29b124973164a164fde5f"
    sha256 x86_64_linux: "1e65207b55d3c04987dd3679145db28e5952aa6cb2cc5bbf8aa227eb3cfd7b5a"
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

    kernel_name = OS.mac? ? "osx" : OS.kernel_name.downcase
    bin.install "generated/#{kernel_name}/release/64/dmd"
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
