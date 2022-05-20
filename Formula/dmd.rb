class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.099.0.tar.gz"
    sha256 "8c8575b2b68b7dfe236fec13bbdf26d063365b4ed08563320f429b202c5b8a2e"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.099.0.tar.gz"
      sha256 "de1f9ae7c15806bcd1459d56c7ac7216479ff88f5a3b0ea883d50d639f7dfc42"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.099.0.tar.gz"
      sha256 "10075c768d5a5fb3e03f044eabee56ebf7889be8dbcbc2196300c3e23aafa2f7"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.099.0.tar.gz"
      sha256 "8a0c6b3aa98647342bd2e22832e7268a343c5d86f6ae39729f2637421dd7a607"
    end
  end

  bottle do
    sha256 monterey:     "7915962e2ac77fc452265b0ea9b266532df63429052f7ab3728680d178e9c0b3"
    sha256 big_sur:      "36df3f738905762d0de7778fb701c481addd3334d9f3747d1c028417a4886168"
    sha256 catalina:     "2850288b2740f2b638e5bc9842d82671fc677c38cf4479ec98edc0bf01d8d9d3"
    sha256 x86_64_linux: "e6ba5774143a9dd4dffce3e2befea836910f58237e1723a0818be81ce4667bcb"
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
