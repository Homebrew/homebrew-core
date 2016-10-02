class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.071.2.tar.gz"
    sha256 "bb6195a9cd5351e57ba4dfaf3af3bbf31387a3480306adf2ca317dfc5146cc3f"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.071.2.tar.gz"
      sha256 "4a58d1fb8e7427d2302b3830dd5b423cd22b48ad19f7db93c7339d46fd030cda"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.071.2.tar.gz"
      sha256 "0cd1ef9f8f92d05f58f93b87271a3cfc2ce9ad156e15069f055e5d1edef98fa4"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.071.2.tar.gz"
      sha256 "392f3766f5f2ac52e19fbacfd37fb9ddba507a53e77fe98f0c5aeca3238ec000"
    end
  end

  bottle do
    sha256 "887320f50135759fcd97ef2528421ab3d8716afe899217a35f704b66dcef74fb" => :sierra
    sha256 "dcad29345a9ce3670734628eca339c9bb4dafbc3dcbfe3e0c9df022530e29031" => :el_capitan
    sha256 "ec3d0ed9e0531b9accf65e122f113d84cde32d9a3f5025d861ef6f37e8bd4156" => :yosemite
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
