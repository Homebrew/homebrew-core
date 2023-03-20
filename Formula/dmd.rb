class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    # make sure resources also use the same version
    url "https://github.com/dlang/dmd/archive/v2.102.2.tar.gz"
    sha256 "98125e1ffddfa0490edeb6cf1d9bc7fade701f210182d2350b56bf8c10b890f2"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.102.2.tar.gz"
      sha256 "e4fcc5b2eacb38a1921590865535cf93be6344ffe852ebb62f2426db8fae38e3"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.102.2.tar.gz"
      sha256 "95935f1b887a5eec2353c03063b804de194a490473bcf3140b907a7152cd3cdb"
    end
  end

  bottle do
    sha256 ventura:      "f7b07ff630761f42724db92808cbe2d641fc76790e11035a0993d6ba75f99183"
    sha256 monterey:     "522a6aa91a13af199f286cbee3539883af859bb5493d5076466a39e337616407"
    sha256 big_sur:      "2a5f6c200165fd04abe53570fe72db81a8744d14feba4ad43f3c3cbcd2ceac3d"
    sha256 x86_64_linux: "18147101d7a8d655760506fbf8a648e539c74ee7a86d724a575be2e75cd1e150"
  end

  head do
    url "https://github.com/dlang/dmd.git", branch: "master"

    resource "phobos" do
      url "https://github.com/dlang/phobos.git", branch: "master"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git", branch: "master"
    end
  end

  depends_on "ldc" => :build
  depends_on arch: :x86_64

  def install
    dmd_make_args = %W[
      INSTALL_DIR=#{prefix}
      SYSCONFDIR=#{etc}
      HOST_DMD=#{Formula["ldc"].opt_bin/"ldmd2"}
      ENABLE_RELEASE=1
      VERBOSE=1
    ]

    system "ldc2", "compiler/src/build.d", "-of=compiler/src/build"
    system "./compiler/src/build", *dmd_make_args

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      DMD_DIR=#{buildpath}
      DRUNTIME_PATH=#{buildpath}/druntime
      PHOBOS_PATH=#{buildpath}/phobos
      -f posix.mak
    ]

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    kernel_name = OS.mac? ? "osx" : OS.kernel_name.downcase
    bin.install "generated/#{kernel_name}/release/64/dmd"
    pkgshare.install "compiler/samples"
    man.install Dir["compiler/docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]

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
    system bin/"dmd", "-fPIC", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
