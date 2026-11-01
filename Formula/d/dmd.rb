class Dmd < Formula
  desc "Digital Mars D compiler"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/refs/tags/v2.113.1.tar.gz"
    sha256 "1902ac87b33586b4ce1ce3d6095181b2002e620cc337f6511ae01a4779faa707"

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/refs/tags/v2.113.1.tar.gz"
      sha256 "7a516c5c9c6bc8f20a6e1576a98770e8ab18867066e2f31996fdf4cbb9571c80"

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
    sha256 x86_64_linux: "823a7450eb2a24b11a41d1e6b6dad283a40f92404a04124cf911f9d760e5c461"
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
