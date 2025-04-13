class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/refs/tags/v2.111.0.tar.gz"
    sha256 "40b64dd049642dcdaef60815451d5c718ef6c861b6a02a3da998a6a3377900c1"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/refs/tags/v2.111.0.tar.gz"
      sha256 "b4a7beb5acac54457dc6dc2ab0899a713e446be10a9a584089238babf4e16d5a"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 sonoma:       "58cc3b27e8e385cefb7105d6943a0ae6dec8718ca504901a165b6074bdf3d9d5"
    sha256 ventura:      "dca27059dbaa82f6785ccf0255a5409ba0975d4ef525cd11945d78e82f3c4328"
    sha256 x86_64_linux: "bd161341d03c4569d99398c857c4dba58118497300223acfce69fd747da0bca9"
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
    (testpath/"hello.d").write <<~EOS
      import std.stdio;

      void main(string[] args)
      {
          writeln("hello world");
          writefln("args.length = %d", args.length);

          foreach (index, arg; args)
          {
              writefln("args[%d] = '%s'", index, arg);
          }
      }
    EOS

    system bin/"dmd", "-fPIC", "hello.d"
    system "./hello"
  end
end
