class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    # make sure resources also use the same version
    url "https://github.com/dlang/dmd/archive/v2.102.1.tar.gz"
    sha256 "7c04e3da17f907cfe80ff9374fb12fcfb840bf6eac4c7c1ba87eb9a0491ae345"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.102.1.tar.gz"
      sha256 "dc6905a97c08115849f408e0a0d2ff89876610092844e52181821231dbfc37f9"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.102.1.tar.gz"
      sha256 "8918280a41c18bc2b20d240a26b4f35eaee6df8b52b9ea4b45c42b50e991ac69"
    end
  end

  bottle do
    sha256 ventura:      "5f824220f7f7ed61915627d3046399dda98fc9152683a8690d3ce488f0bea629"
    sha256 monterey:     "46f5f36956cee846a9b934170c42c04894295ebf28951091e5008cdcf29fdd56"
    sha256 big_sur:      "9d050c3631225ebf0f1383e5a9f9bf78c33f9dfc7858088776a2319b0a69c826"
    sha256 x86_64_linux: "34ffbac00d5c035c2047419c62f6e13abda393e5725c03e18a2ecd03c8944867"
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
