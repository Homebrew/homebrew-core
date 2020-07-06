class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.092.1.tar.gz"
    sha256 "765226feaeaabcfdc5d771566af16058d51b017b8b19c5d91a3faa9c69bdd373"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.092.1.tar.gz"
      sha256 "c28a60ed4dcb7b1d0e171d45f48a5876814ca629e5359592806074fcd4609cc4"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.092.1.tar.gz"
      sha256 "15547631ce3cb618cc096da728746dc725d429cf0796e646c310efb21e345ce1"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.092.1.tar.gz"
      sha256 "8db4d21c6348fc25143d532e56f345198a384cce85c08979aca2476211e15113"
    end
  end

  bottle do
    sha256 "90cd978b1793cea1804fc18c99c46f64966b392b634bcf3874f5a7846d264bd0" => :catalina
    sha256 "8710eba4bf54759b19a89aef4c77188ceb1c3da9f6eef5d100986309f2bd625c" => :mojave
    sha256 "ef79ba1e5aa6e2605dc601e5cd4618dd66854fe3813b10cabff2352877485e9d" => :high_sierra
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
