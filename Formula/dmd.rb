class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.078.0.tar.gz"
    sha256 "58a6afb41e6fe5b69399cb2354e0c7413e84f767128a8d9e003f0d6a9b167f45"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.078.0.tar.gz"
      sha256 "02118259c8570709aefed1b2452d67cedffed3a4b1c1507071fb58269842914a"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.078.0.tar.gz"
      sha256 "da3b0d54827a461a398f90554a5d0a2f3077eaaaec2534b40861e34c33ec179a"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.078.0.tar.gz"
      sha256 "5d3de1524bb1a024649a065e2567893c88cc4dba17ae9bd6f576e11bc91533ec"
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
