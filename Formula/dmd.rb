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
    sha256 ventura:      "304ca4ecaa135222127dfa01c4b1ddfff7ba63cbf870af694a2070acb18b0042"
    sha256 monterey:     "e54e0c9ae68fb5f97583eafc1eee2dd4c2d44711eda230f61c31ad4630fd9718"
    sha256 big_sur:      "0e8034fbd2f8ffbcab6ec9fa9c30e3ebd5b2fcc156e39fc42057f890ba4ed227"
    sha256 catalina:     "fef67e3bc8fa339a1ee41e49a1dd403bd3dfc2c3b6ef691a47d3b952d36c55a0"
    sha256 x86_64_linux: "18d502a96663c3d8a70c3e6b8b43d61ff675768cadccf24df0c3c701ce67f5ff"
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
