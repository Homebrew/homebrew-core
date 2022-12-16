class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.101.1.tar.gz"
    sha256 "e369396dbbe4eec9311122fa24c975688b209a000bf2062a9f86b49ab2e4a7b0"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.101.0.tar.gz"
      sha256 "c88040678f2478cdedd1954d25058a3a87c3c858acd2528c6b9d60852abe7c5d"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.101.0.tar.gz"
      sha256 "a74cdc177cfcb7605d803787774497e11d499428459f1f2fd2384b41b93825de"
    end
  end

  bottle do
    sha256 ventura:      "c6066c448834620489dbf6481ae2233da0e7da055f07dae8d144c63281c1b8df"
    sha256 monterey:     "90623baa71ebe8039c546a9b90b642ae3f4efc7c353bc1c8f2be61fee3991168"
    sha256 big_sur:      "544b5326c155da76fe61318bff98697b88949a33eaec79d6c8d1fe69fd55fc2d"
    sha256 catalina:     "d1d76fc20cd153f1dd18e33ddd49319ee91fc727fb832105612f5a29714e98be"
    sha256 x86_64_linux: "24a89eaf002814aaa4b11e3877825ef1b32c70577773c4cd8413b186598dac06"
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
