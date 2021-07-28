class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.097.1.tar.gz"
    sha256 "6833efa0f0a47d2926680364da56246947ad2eda75243de609fa1cf6e46746d3"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.097.1.tar.gz"
      sha256 "f3f47cf0cfc99e3643752db87541e36e637c94874213d31c356d6af4fc6fc113"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.097.1.tar.gz"
      sha256 "64d349a8c98967ca1c2b1daf0ef904b043838c5b7a11e7e15c7b0383c78544a1"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.097.1.tar.gz"
      sha256 "e42c3bac10266e44cb4939124fce0392ce155979c1791981e30d8166f44c03ab"
    end
  end

  bottle do
    sha256 big_sur:      "7b13c3953ee766dd708d49f739acc6c211441bf849a09ea8cffc7da1a26b47da"
    sha256 catalina:     "fe1f3676f1a382ea3ff1086e2e0a2446c8eff174387d02a263bec32a72104b95"
    sha256 mojave:       "ac360eb79ccbdbd555fc6795b189f8f71aa2eebe2d9b37c272935af2c5033c33"
    sha256 x86_64_linux: "ed13bebe1a84eb7a42833f713172ecff0af9f521388f7c5beb0cb4bc83730efb"
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
