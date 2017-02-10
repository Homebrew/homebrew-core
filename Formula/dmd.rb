class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.073.0.tar.gz"
    sha256 "61483ea2c395341d05e65ce7e08a978cceff33ed3818f9ffa009a2f2da6929d5"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.073.0.tar.gz"
      sha256 "542adeac69b93c728a3760273d8d50ec43bf609736c526a58976b3822d5aa883"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.073.0.tar.gz"
      sha256 "2a0176039fcfcd6c05eff5f471e7659c2d368a8b2cd7f7de323d49d3d8b45782"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.073.0.tar.gz"
      sha256 "fbc04a5521eac7a25d9f210a44d9ae9b6843466ae4560f9dafe29d65771c2e06"
    end
  end

  bottle do
    sha256 "59ea4775ead963332333068e070b4456df008c36bc31cd8600c8caac310d72fa" => :sierra
    sha256 "dabf9f179337f76b82ac2940fa1de106141d3e8a1e11f331658c998fc03f714d" => :el_capitan
    sha256 "6cf60c26e372805784388702ebdc87457a3c86da5e3b5d69a5f3b84e08579c72" => :yosemite
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
