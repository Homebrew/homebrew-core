class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    # make sure resources also use the same version
    url "https://github.com/dlang/dmd/archive/refs/tags/v2.103.0.tar.gz"
    sha256 "98d02ae197dc3ec7959343f6a61ec18294d4e57d61f7749287c6d56270c3891f"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/refs/tags/v2.103.0.tar.gz"
      sha256 "65d0d5ff4bce2ea881fc5db5140ec14f7567e87d4dfcdb16f400e1e4457e9221"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/refs/tags/v2.103.0.tar.gz"
      sha256 "591bf56d7c8aa45205a3533438fef5bd48007756446f5cf032fcabcc077afdd1"
    end
  end

  bottle do
    sha256 ventura:      "200aee65f276419577ba2316433c1b3d793f9520e907ba166c8733ed1ffeb3d4"
    sha256 monterey:     "4a13fe5652c58fd90b3e70559ffecd54ce73eca5977be8191864ebf59b672b07"
    sha256 big_sur:      "f79dcb83dd943a13a79cf509864c74037708f28c233ca523e9f2e1b2bb3cceec"
    sha256 x86_64_linux: "c2d2e3f288b5f75fac14881883e04b38134983736de161ab47717e5639ebba6e"
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
