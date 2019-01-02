class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.084.0.tar.gz"
    sha256 "4774da1f40f3ac690cec08690e6b90cb2d33432cf82deb5d80216ce6689d8103"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.083.1.tar.gz"
      sha256 "4c81bb2e9397d9615887037354d1a7efbe1eed2721d48771cdd8970dda5f6c98"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.083.1.tar.gz"
      sha256 "4a5f89c6911f8d208ed6a4b941d6ff9cc8ef708dab3e65c1d978dc372a999936"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.083.1.tar.gz"
      sha256 "78d90dcda6b82d3eda69c30fa2308a8c8f1a3bce574d637806ca1af3c7f65888"
    end
  end

  bottle do
    sha256 "863e17c209fc76743e91213eb0568ed32e996a3c489f15ebf856d203308dbfd7" => :mojave
    sha256 "5675ba828166d04cf663c2aebbfb9059055c6cd58533e022b709ebdfb5eb75a3" => :high_sierra
    sha256 "f2add4eb9517c974a9f51d0371291d2ff8e3b2c8cdbff8d610d7febd2dfee3bc" => :sierra
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
