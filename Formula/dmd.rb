class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.081.2.tar.gz"
    sha256 "390b51ff994da52fb02fd95ce71282540caa2e8ffd38945b37ee700559b4a3ec"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.081.0.tar.gz"
      sha256 "ab8a7b5c99a94a8e58b6761309997f5b54b317269769a8fe3b4a994aa65a4946"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.081.0.tar.gz"
      sha256 "cd5785ebd83a5edc11cb31732042582c4a741c4aca491e538dc4ee382a60881f"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.081.0.tar.gz"
      sha256 "452ba1709dc6aa50a0a4363916119d9ed7bd261c421483c2b187f55f8c774d17"
    end
  end

  bottle do
    sha256 "8b2428199cef0f5d3eadd0e7f947d24c530597ae21d2b544afae54bb8f9509cc" => :mojave
    sha256 "cd78f901eae3971a0bc6967ebf7da89d58f86a0a23a59b1c7afc95179b0a2b4d" => :high_sierra
    sha256 "0916214f85d530de232bf969209a9326e5b5cd83421b581025c142f0a745b4fe" => :sierra
    sha256 "2e0357261b2b1d3ece749d287c6496790831c9aa343499ff5b4b8384ba5b5423" => :el_capitan
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
