class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.084.0.tar.gz"
    sha256 "4774da1f40f3ac690cec08690e6b90cb2d33432cf82deb5d80216ce6689d8103"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.084.0.tar.gz"
      sha256 "9d1b2810c88a552ae568b3e27331d0fe926938accf38030007a794e7f6616363"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.084.0.tar.gz"
      sha256 "bb979157d6147af86796ae8e4386c2d728d1a81a3953a24dd98efa391425c354"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.084.0.tar.gz"
      sha256 "443de9678eb054d0301c16e501f06d92a750c9c94d4d3e33ce793ed461725ce3"
    end
  end

  bottle do
    sha256 "266bae766df8832e83b00729428ca5d65ba063f463a0c92e1a7b3467487b6940" => :mojave
    sha256 "1c860ef97f2a6b6d60369102a683951f98c81cfcc4c11f3be59a680596de6373" => :high_sierra
    sha256 "71c6175931b12b1050e7153ed01ff6d368d3b7963feab129e1bcaa1a228d6bc8" => :sierra
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
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "BUILD=release", "-f", "posix.mak"]

    dmd_make_args = ["SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "ENABLE_RELEASE=1"]

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
