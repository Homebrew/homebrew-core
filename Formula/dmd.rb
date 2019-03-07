class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.085.0.tar.gz"
    sha256 "5e45e9ccf07fb0b500f63500b143f8b66dbaf3f4348d2a5250799fc2d22f8225"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.085.0.tar.gz"
      sha256 "b490b04afbd771a51188fd864497b5bf01b28d5a49fb06da420036fc8ea2f7d2"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.085.0.tar.gz"
      sha256 "c2018c8275cf83b542a9cc2c8dc99a770e9b8b89e638f8971dc9945bd0e5385e"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.085.0.tar.gz"
      sha256 "80a29cc9ce0369b1598b22c30e933a27f544ab7c95636018d4dd017e93abfc3b"
    end
  end

  bottle do
    sha256 "dae3a61fc406454bd41316874fa04c07086b77b8b7e0b4f614b0000abda94018" => :mojave
    sha256 "044897a252046800ad08a94846e06c3355ffa94be5e5b2dc6ada7afdb3fac2dc" => :high_sierra
    sha256 "10daa439f122dd05d71c8c6e86757de824e716e592d52b296a5cf8d089b92cdb" => :sierra
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
    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      -f posix.mak
    ]

    dmd_make_args = %W[
      SYSCONFDIR=#{etc}
      TARGET_CPU=X86
      AUTO_BOOTSTRAP=1
      ENABLE_RELEASE=1
    ]

    system "make", *dmd_make_args, *make_args

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
