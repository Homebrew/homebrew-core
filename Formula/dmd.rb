class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.072.0.tar.gz"
    sha256 "a5fc4f4310a757b732634cbb0695f65fdd149201f6d1f3d7d9e3fa809e797803"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.072.0.tar.gz"
      sha256 "5b1b9c2e55ff6c7bc7e4e14cfe44b83aab7946b15fb12880327b5c7cbba9cc6e"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.072.0.tar.gz"
      sha256 "79d4a5597e30ce0cfd3c094fa176f259bcdbc5994f86ab4cb530280cd44a2459"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.072.0.tar.gz"
      sha256 "671a44d58b7adc0d09ff0addb275028b373fa9cbb21e44f9ef269d5e428be2cf"
    end
  end

  bottle do
    sha256 "4e8247bbb15fbafda93eeda27218876ee367985ec616efa3cbec1a24a901f032" => :sierra
    sha256 "a062c5ba9abc729243def47bc5bf5f33bf915519752ce063739be2483c7d4809" => :el_capitan
    sha256 "160b069a1e89134d622cfd1fdf8106deb95f44b200fb8a76b00fb0183f2c5a22" => :yosemite
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
