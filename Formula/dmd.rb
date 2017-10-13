class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.076.1.tar.gz"
    sha256 "242e0dccf0b5aabd3a886c1aca32e6b197dfef015005f45bd36050f8a4fded5c"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.076.1.tar.gz"
      sha256 "28950dce412e3bba27030464eb91e99621f4f2c0cd0ba680a6361911776f89b0"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.076.1.tar.gz"
      sha256 "d253e6f23d91b8d544dea0b3c8ca4a13abfc2b13642f31f76b6ad2c1dd49615b"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.076.1.tar.gz"
      sha256 "cf42d4e5f9ceb5acfb5bd3000dd9c1ed7120b136f252b33b07fb026f36970e77"
    end
  end

  bottle do
    sha256 "8117f71c4744d92226827bd7f2e71e55ff34490bd2b8890edf2deccdcb8e6cad" => :high_sierra
    sha256 "c58da079861e25df56ef88da13189f029fe93de528c1ad2ac66533fa97d8482d" => :sierra
    sha256 "13789fff9c570ffcad532fcac9ebafa59ea97f0e5dd65158436ed7d2d5ae5108" => :el_capitan
    sha256 "20461131f122509ceaccac8ab988aa88fa7f0411d332c3877b23c6152a9ad74b" => :yosemite
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

    (buildpath/"dmd.conf").write <<-EOS.undent
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
