class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.071.0.tar.gz"
    sha256 "e223bfa0ad6d3cf04afd35ef03f3507e674ceefc19ff0b0109265b86b7857500"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.071.0.tar.gz"
      sha256 "54f9aea60424fe43d950112d6beaa102048e82f78bf1362d20c98525f199f356"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.071.0.tar.gz"
      sha256 "3d3f63c2cd303546c1f4ed0169b9dd69173c9d4ded501721cd846c1a05738a69"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.071.0.tar.gz"
      sha256 "e41f444cb85ee2ca723abc950c1f875d9e0004d92208a883454ff2b8efd2c441"
    end
  end

  bottle do
    sha256 "3b06c86da15f6cf45fff69b10db6e95a38f7eb8badf65bfce22ea6a73fcaa3f7" => :el_capitan
    sha256 "31ef9523b4bba0466d1c20bc7b84a9e293be65ceba64195fe76d4dd22b7d9707" => :yosemite
    sha256 "4fffd14884ab78b936768208d7269bed193ff52cc30de53a55ead0bce0e9c47a" => :mavericks
  end

  head do
    url "https://github.com/D-Programming-Language/dmd.git"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos.git"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools.git"
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
