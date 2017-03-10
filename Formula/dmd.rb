class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.073.2.tar.gz"
    sha256 "1cd983d73b0fa1a20232fb46dbc3a39434adfa00fc7668563983ec8ca210726a"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.073.2.tar.gz"
      sha256 "9c0c1a818deb6a0d410f83f067450cc5b41287328c44c2d46c0d2e7de84aa68e"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.073.2.tar.gz"
      sha256 "6a3b16649a33bcc3db522404a1fe98f046eedf082a96648f7972ab112c2cb289"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.073.2.tar.gz"
      sha256 "6e702dcbf73d4673a8a9320a01170ad1ae59945a3646d343b14c4cac88b735e6"
    end
  end

  bottle do
    sha256 "d508f37e7418b273c70d0660047a3e89f32fec3f53b5325a9fddb390958a6dee" => :sierra
    sha256 "c828d2ab526416fab04f9dfb0f615839434a1ff9f1eaebeb43bf812ff212cfc2" => :el_capitan
    sha256 "cfd39c64ab7bb3495c795435ad5b91eab0553f6b467efa0e539d1b2bcaa4ab15" => :yosemite
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
