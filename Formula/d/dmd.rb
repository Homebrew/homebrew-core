class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    # make sure resources also use the same version
    url "https://github.com/dlang/dmd/archive/refs/tags/v2.108.0.tar.gz"
    sha256 "35cd47ead6737615a4b5c82dd80ea4b5f84cf231a10bf1c3487f4527adc89424"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/refs/tags/v2.108.0.tar.gz"
      sha256 "804021ee34612836500dfe93992673bb430fba5caec95075108908f2f0f6a2d3"
    end
  end

  bottle do
    sha256 sonoma:       "c589fe4689d29f4aa3af565538d84be4f12db759d70569a0a5aad4e41a29308b"
    sha256 ventura:      "8815fc56ec97162c1db5a490c380378382d4920185b349d1b31dc7949f9496e3"
    sha256 monterey:     "bdc0956142853c22813e52315df1fcd9463662dcfc4f9dc4f2f3ab863bb2c735"
    sha256 x86_64_linux: "8eb9c149b147173daef31aea60d9513a06a71f81373ca3e496cd014101c3df78"
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
    odie "phobos resource needs to be updated" if build.stable? && version != resource("phobos").version

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
    system bin/"dmd", "-fPIC", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
