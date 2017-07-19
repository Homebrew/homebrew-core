class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.075.0.tar.gz"
    sha256 "9c18019485eb65a11cb60645701fa0a35aa7f910f5a399a897fa8297c14c3df6"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.075.0.tar.gz"
      sha256 "a64e5fa94d7b367b3e9d08b03c460c10de5dcced3418bbadeb53707a0a8d2bfd"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.075.0.tar.gz"
      sha256 "0d93d3d47be24995a1b1e97f0e04e7625d9e8b567e8c4a70d675af077f368f48"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.075.0.tar.gz"
      sha256 "2fb12e20fa62b3d3ffda60d2b1bed53485d7312c02d0ed10e4178f8859eb27dc"
    end
  end

  bottle do
    sha256 "b1724eb67a864dd6a804cf823085087d15313c0db0310d49bb2f1cb3b743b033" => :sierra
    sha256 "61a2eb09ffcfe61c8aea379a21291ef79d184725f49664e54f6f2cb3a087d167" => :el_capitan
    sha256 "ebed6a8c951e6530286a3f5d9d3396ab42d62341d65df7a072986f9b5fb12007" => :yosemite
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

    if build.head?
      make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"
      (buildpath/"druntime").install resource("druntime")
      (buildpath/"phobos").install resource("phobos")
      system "make", "-C", "druntime", *make_args
      system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

      resource("tools").stage do
        inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
        system "make", "install", *make_args
      end

      (include/"dlang/dmd").install Dir["druntime/import/*"]
      cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
      lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

      conf = buildpath/"dmd.conf"
      # Can't use opt_include or opt_lib here because dmd won't have been
      # linked into opt by the time this build runs:
      conf.write <<-EOS.undent
          [Environment]
          DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
          EOS
      etc.install conf
    else
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
