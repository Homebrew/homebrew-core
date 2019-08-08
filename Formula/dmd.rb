class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.087.1.tar.gz"
    sha256 "4239b8b6dc09acf3cdaa1c924f3a2b3cddd0fb532f817c4027b8966f1e96b3a8"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.087.1.tar.gz"
      sha256 "19b7f18e11934a582d67dcb39c3ea91d5c24444c3be311f93160e0016ccc58fa"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.087.1.tar.gz"
      sha256 "84c7120e972255b4c66c532ff771ecbbb615b87140d0ffcb214d04b0d418f28f"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.087.1.tar.gz"
      sha256 "a7cb8b217f2841f1ebe513ac5090d6ef77e03dc72bf2047bf92632c263941810"
    end
  end

  bottle do
    sha256 "6114ef64687d770755d1cdaada475726c869ed33f98773501d4fc3303707927b" => :mojave
    sha256 "cee9845763c02401b79870ca5e0ea5a8d0b1aead9859bea187ca08b1a4ec4bdc" => :high_sierra
    sha256 "c829267c0e68d3dc8adcfe1018d75cee1023f42af681d7f6559a49f446191a07" => :sierra
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

  def install
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
