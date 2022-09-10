class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.100.2.tar.gz"
    sha256 "84e647f83c5e231d6b64158334105321d26b3e31abdeb3bbdc0f0ea8130cd30a"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.100.2.tar.gz"
      sha256 "26e160c5b78f8ccc1fa5e06d9897be28b3a92b666efe3663d611963e5c9f85c2"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.100.2.tar.gz"
      sha256 "ceb033c9c8fac4e43b33e026a9f48e229a955e66dc7dc31e2e6a4a5b99522012"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.100.2.tar.gz"
      sha256 "83edea545d7afcbd3b6e3807652c668e9565450f5cd7fdf32ca4295eb365002a"
    end
  end

  bottle do
    sha256 monterey:     "f15764b4c8e05f8aebf73095b6166e492df5396a2099f86cc91c8ac94ca4b2ca"
    sha256 big_sur:      "d3fe0e15f6252c33f32f95c9d23fbd2daf160f10a75fe86bc9842d42cdaddd4e"
    sha256 catalina:     "be1429a8095dc8c2cfd51a2f83437fa70e2a70b2b36966177de88ca7e454cb3b"
    sha256 x86_64_linux: "aa97c8376d5416487981088437c0db4be9b4c752a91a08366819f62960151d89"
  end

  head do
    url "https://github.com/dlang/dmd.git", branch: "master"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git", branch: "master"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git", branch: "master"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git", branch: "master"
    end
  end

  depends_on "ldc" => :build
  depends_on arch: :x86_64

  def install
    dmd_make_args = %W[
      INSTALL_DIR=#{prefix}
      SYSCONFDIR=#{etc}
      HOST_DMD=#{Formula["ldc"].opt_bin/"ldmd2"}
      ENABLE_RELEASE=1
      VERBOSE=1
    ]

    system "ldc2", "src/build.d", "-of=src/build"
    system "src/build", *dmd_make_args

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      DMD_DIR=#{buildpath}
      DRUNTIME_PATH=#{buildpath}/druntime
      PHOBOS_PATH=#{buildpath}/phobos
      -f posix.mak
    ]

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
    system bin/"dmd", "-fPIC", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
