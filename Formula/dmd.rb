class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.071.1.tar.gz"
    sha256 "e08038398dadde39dd0ee241de9b686d6db2f3aaaa345cf2524e98bd3afca6ca"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.071.1.tar.gz"
      sha256 "3acf73a4adb3d42cfca6bc14e83ea2108c733df6e9206695454355259bd787b4"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.071.1.tar.gz"
      sha256 "12da99fbb8deead36ca3d357f27b4a19ab46bcba45d3c5e2b0b01c226a9d76e3"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.071.1.tar.gz"
      sha256 "459114907bd359fa0aa6843d7add561a1cdf9e25ce26c78cc6f9cc2a2b095e4e"
    end
  end

  bottle do
    sha256 "6b8f1d2c07eeceda638ea9c572365fbb68dcc276c6e2069e8f861031ddfe82b4" => :el_capitan
    sha256 "03bb309fd744496c99f82466ecd793a598c3fd4ab15b4b342ace457442ecc1c5" => :yosemite
    sha256 "6ae6aaa96e2de26bf1e68e450d600dae4b12e3282b4e6882d9e498005c9a967a" => :mavericks
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.071.2-b1.tar.gz"
    sha256 "14111e8347a54837e2f06347b1b8a38f644435589a9aa8b3672e6928295a5ad8"
    version "2.071.2-b1"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.071.2-b1.tar.gz"
      sha256 "3cc3e7bbdf3fbc0b0e9f5d472088921bd2c9f20e39e40dcd47aae4758c59072c"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.071.2-b1.tar.gz"
      sha256 "f9913c9e6653c10c9a0377878dd8f82a921c576af6e1be5620b81ab28deb2dfc"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.071.1-b1.tar.gz"
      sha256 "5f1a9de622f5228b7bbea05597461b0cd167cf9e64d3fe936a04bb02690f5279"
    end
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

    # VERSION file is wrong upstream, has happened before, so we just overwrite it here.
    version_file = (buildpath/"VERSION")
    rm version_file
    version_file.write version

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
