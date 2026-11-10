class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/refs/tags/v2.114.0.tar.gz"
    sha256 "54f1a8528dba28eebe7d2b69c19ebf76410a03432655a0713d2a1d7acb78fab0"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/refs/tags/v2.114.0.tar.gz"
      sha256 "c02e654d57059547d3ccc41b4e2bb8d0ba0fad4604c67632259983bcdfdffdaf"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url "https://downloads.dlang.org/releases/LATEST"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 x86_64_linux: "d5c219e279810bea09eab40787f9d6fee321d965545eb2687c2ec2b3ac309c97"
  end

  head do
    url "https://github.com/dlang/dmd.git", branch: "master"

    resource "phobos" do
      url "https://github.com/dlang/phobos.git", branch: "master"
    end
  end

  depends_on "ldc" => :build
  depends_on arch: :x86_64

  on_macos do
    # Can be undeprecated if upstream decides to support arm64 macOS
    # TODO: Make linux-only when removing macOS support
    deprecate! date: "2025-09-25", because: "is unsupported, https://docs.brew.sh/Support-Tiers#future-macos-support"
    disable! date: "2026-09-25", because: "is unsupported, https://docs.brew.sh/Support-Tiers#future-macos-support"
  end

  def install
    odie "phobos resource needs to be updated" if build.stable? && version != resource("phobos").version

    dmd_make_args = %W[
      INSTALL_DIR=#{prefix}
      SYSCONFDIR=#{etc}
      HOST_DMD=#{formula_opt_bin("ldc")}/ldmd2
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

    (buildpath/"dmd.conf").write <<~INI
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    INI
    etc.install "dmd.conf"
  end

  def caveats
    <<~EOS
      Ancillary tools (e.g. ddemangle, dustmite, rdmd) are now in the `dtools` formula.
    EOS
  end

  test do
    (testpath/"hello.d").write <<~D
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
    D

    system bin/"dmd", "-fPIC", "hello.d"
    system "./hello"
  end
end
