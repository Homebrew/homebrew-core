class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.080.0.tar.gz"
    sha256 "bef32e69f73ec2fd8482a3649797d85e4740d2c2019b8e03b37524ba58acec92"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.080.0.tar.gz"
      sha256 "e8b856d0927f3600003dddb049f091a2a50c74ad35182ffd1f88d6faf9079d77"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.080.0.tar.gz"
      sha256 "ec24c2bf3705edcdb33879db4f4ee5bab7d226b77920a29f945bd0665c5b5be4"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.080.0.tar.gz"
      sha256 "5fa8b58a2686685a1d94bf8d4518f2756a6d60a063daddc7993f9ac8cc58c695"
    end
  end

  bottle do
    sha256 "79c618dbcf2c252ee60ba8c33c5f1ab7a9ec410a6b12b825cddaf72028644f3d" => :high_sierra
    sha256 "063a291a26c1a277ebd6a3fa18ead76971708bff3156c28e830ac9414d8c908b" => :sierra
    sha256 "75496127e9ea51049752d858d217bff35043fa5c1daeedd755948ba89a0e3c7c" => :el_capitan
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
