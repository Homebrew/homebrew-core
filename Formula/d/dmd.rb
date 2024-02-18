class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    # make sure resources also use the same version
    url "https://github.com/dlang/dmd/archive/refs/tags/v2.107.0.tar.gz"
    sha256 "aa6983f46cb0672626d22c00ba23f6e4904dd0c81ade6e6acc1564fdabcb7cfd"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/refs/tags/v2.107.0.tar.gz"
      sha256 "ca0d2cd7f7420f6fafed943bfe4f36cc7396f9121bceb4e741d87ced17b896d0"
    end
  end

  bottle do
    sha256 sonoma:       "8d21fd6a0118d067f91bbeca04843a06a5f42f59b17482e4c15093fe45609c05"
    sha256 ventura:      "2f5d1e055e19fa15dde3c4c9d39511d4b5676f585d1b63a3bd3fd8293d5812fc"
    sha256 monterey:     "5a935055e7ca681d0f16124db10afa7e2ec77bdfbae135172b7abf58088c618d"
    sha256 x86_64_linux: "9358da94d5f4c1124f9159985f3936196f05a126698d6848c2c6f1e3520176f6"
  end

  head do
    url "https://github.com/dlang/dmd.git", branch: "master"

    resource "phobos" do
      url "https://github.com/dlang/phobos.git", branch: "master"
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

    kernel_name = OS.mac? ? "osx" : OS.kernel_name.downcase
    bin.install "generated/#{kernel_name}/release/64/dmd"
    pkgshare.install "compiler/samples"
    man.install Dir["compiler/docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]

    dflags = "-I#{opt_include}/dlang/dmd -L-L#{opt_lib}"
    # We include the -ld_classic linker argument in dmd.conf because it seems to need
    # changes upstream to support the newer linker:
    # https://forum.dlang.org/thread/jwmpdecwyazcrxphttoy@forum.dlang.org?page=1
    # https://github.com/ldc-developers/ldc/issues/4501
    #
    # Also, macOS can't run CLT/Xcode new enough to need this flag, so restrict to Ventura
    # and above.
    dflags << " -L-ld_classic" if OS.mac? && DevelopmentTools.clang_build_version >= 1500

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=#{dflags}
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

  def caveats
    <<~EOS
      Ancillary tools (e.g. ddemangle, dustmite, rdmd) are now in the `dtools` formula.
    EOS
  end

  test do
    assert_equal version, resource("phobos").version, "`phobos` resource needs updating!" if build.stable?

    system bin/"dmd", "-fPIC", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
