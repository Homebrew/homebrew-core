class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.080.1.tar.gz"
    sha256 "50f38e3bd1ac2ce05442e2ab061c6544e0c346eb6d03eb95204238b963ee25a0"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.080.1.tar.gz"
      sha256 "ca075552c3358682937ea8e3412877bfc7c9eddb928575916eabbe9abff58671"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.080.1.tar.gz"
      sha256 "57b7c7ab18879acffe50dfff0a7f988d6e4d0ba9341a4ee1ab6eeecca180d6c0"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.080.1.tar.gz"
      sha256 "d8fe0af45ba0e19a95ad3e1bbb19c005176346bb264c8ddd8272e9195304b625"
    end
  end

  bottle do
    sha256 "7e30798ba76ffb1cc52c7505dd5df712c36a9f0b2efe6fadb03c1b65679df38a" => :high_sierra
    sha256 "ce237c76494638dfca1a647eb2968050988bcab5abb2f7963e7a3cc625c1fda5" => :sierra
    sha256 "5465bd8c3963ab3577452f59638be167bd5dfc3bfb5ffaf1c4d349719e9951d7" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.081.0-beta.2.tar.gz"
    sha256 "94387b0e02fd9713e0940e3272a7d83dfcb73dcffb769ccfa5fc15942965ee98"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.081.0-beta.2.tar.gz"
      sha256 "81a4b4c5a044e2dc2da10c1bb7cfdb155ecc5b3cc22406b9c4a1e093e28539ba"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.081.0-beta.2.tar.gz"
      sha256 "1096059a80e1400555180126e7a5fb73e62ee2dc3ae60871b4c1bf8ed0acbdeb"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.081.0-beta.2.tar.gz"
      sha256 "4cdc8400aa2dc1046ebeea6e4092f56ba3b9f192179a084cb8cc134441bd06fa"
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
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "BUILD=release", "-f", "posix.mak"]

    dmd_make_args = ["SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "ENABLE_RELEASE=1"]
    if build.stable?
      dmd_make_args.unshift "RELEASE=1"
    end

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
