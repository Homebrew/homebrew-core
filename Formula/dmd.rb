class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.077.1.tar.gz"
    sha256 "3860e70c931c7022713f0f3699b6d27d2b118fc39e77231c5431f89ddb9594b3"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.077.1.tar.gz"
      sha256 "43481247c0d854334be2f3584920273141459f89c4d4240c3b188ba943708614"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.077.1.tar.gz"
      sha256 "737a20371cc125e76c5dc0566a5f33db45ab67001ee2a4f8a8e12813fc0a8136"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.077.1.tar.gz"
      sha256 "07d7cfe05344354ab2c6c298d89915998acd2c209ca4165d1f3f9a9dc7191c31"
    end
  end

  bottle do
    sha256 "c72315803f907434aad293305fcb8da4166e59a71cc7c052d8e666be313c9204" => :high_sierra
    sha256 "2337bb684190307760fef486fd137fb27993237a37ca7c246b2398323af6c563" => :sierra
    sha256 "fb1043d5f1533affbd20b21373654fabb06de3d8a4c8e8616573b5282bd349b6" => :el_capitan
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
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
