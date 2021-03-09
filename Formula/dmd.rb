class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.095.1.tar.gz"
    sha256 "ccffae555faf97ccc0c4dbedc338e2121135fe57fc51cfe95ba10c95c8743cc3"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.095.1.tar.gz"
      sha256 "f5e4ff5d98f875595c039cbb3d1886cb5f1ab835b98e5a28704995b8c82a24cd"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.095.1.tar.gz"
      sha256 "7abc1ed3b014d68f24fe0fb2550654ca65ca7db171402d063c0ba119d1567369"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.095.1.tar.gz"
      sha256 "227deb424b82d11eb65a27800df377dc5e9f1b8b496a23df4c28a85a24580d77"
    end
  end

  bottle do
    sha256 big_sur:  "35b1c5bbd6e60e59cd468071d48b9d75a9de1734c3b1090a4cd0d9b1eb59d984"
    sha256 catalina: "e3f00a4729cf637eac841cf9d7c6905d758392b1b23c953e9d3fdb388dbedc77"
    sha256 mojave:   "83134d266a7a69b996c9c2aa6096d42abbc3c38dc0ef21e1fc6e80faff5f3676"
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
