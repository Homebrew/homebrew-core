class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.074.0.tar.gz"
    sha256 "d083323e706ada71fd404a1a41a93786b709ecb23dc49fbcaa6eff4baaad82fe"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.074.0.tar.gz"
      sha256 "17b98cdb732ff017f8a78db2ab82bca6599be7813f8fc8ff8519d6cd06f4f3ec"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.074.0.tar.gz"
      sha256 "f40b7fee9cfcb3c153159f27e8e7cc945a3b2945ab707f76cfbf926edf47ce43"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.074.0.tar.gz"
      sha256 "7cdb66f5a0213e0e0b5cf5b9619873b08fe4424b7e56b59ae13b16209b812cf4"
    end
  end

  bottle do
    sha256 "ac5c2cbc5a4cdfd76f08b0b34cf7a23ec22c54b0d4dbd17bb46769d7011f061b" => :sierra
    sha256 "7ad73a8701677531d7d4d1a694903e333aa315dd876cf768c9aeb38d1c24451f" => :el_capitan
    sha256 "76fa776913e93a515b64f130e232b0097192b21aa5902016ecdea11217f6f48d" => :yosemite
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
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
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
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
