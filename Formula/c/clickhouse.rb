class Clickhouse < Formula
  desc "Column-oriented database management system"
  homepage "https://clickhouse.com/"
  url "https://github.com/ClickHouse/ClickHouse.git",
      tag:      "v26.5.2.39-stable",
      revision: "8462fd8f3dea8603e67666414b2781ab57a8adb6"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/ClickHouse.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-stable$/i)
  end

  depends_on "cmake"     => :build
  depends_on "findutils" => :build
  depends_on "grep"      => :build
  depends_on "llvm"      => :build
  depends_on "ninja"     => :build

  uses_from_macos "python" => :build

  # ClickHouse pins a Rust nightly in rust/vendor.sh; the crates vendored in
  # contrib/rust_vendor were generated against this exact toolchain, so we
  # vendor the matching dist tarballs instead of using rustup (which needs
  # network access at install time and is blocked by the sandbox).
  # SHA256s come from the xz_hash fields in
  # https://static.rust-lang.org/dist/2026-03-22/channel-rust-nightly.toml
  resource "rustc-nightly" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-22/rustc-nightly-aarch64-apple-darwin.tar.xz"
        sha256 "ec3fa42d13a10160ed495bddf6b4836cc2f874cfcf4e165bd66f6498745356f7"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-22/rustc-nightly-x86_64-apple-darwin.tar.xz"
        sha256 "1803f327dd6c4a90b7a784d25e929e165b8566857105d1093da5f19de0ce08ad"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-22/rustc-nightly-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "816dc2ed3f3347faaa1e3a64128855a377604086a549cdd91cb3321e8f0b6bf7"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-22/rustc-nightly-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "83f078a6951e8d94337709633dfeeaf42b7f93e5deff7d453aa01cb69ce98292"
      end
    end
  end

  resource "cargo-nightly" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-22/cargo-nightly-aarch64-apple-darwin.tar.xz"
        sha256 "140f8bc594982127cf7e58332000bf46c795ca25c31c6d0784b55d1eab5ee209"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-22/cargo-nightly-x86_64-apple-darwin.tar.xz"
        sha256 "f12d2fe6f3232e286cb495484329fd87ca917ff2f07906b5f34bda46568beba3"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-22/cargo-nightly-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "4c1a657b7551859e8ebded01941391c94abcc7690d34a81f7a8ba876973ccca5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-22/cargo-nightly-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "23e0d6c60c7ce1b7809e7d22abeb09df7d8b10b33cefb5d578311f9fffbf3b82"
      end
    end
  end

  resource "rust-std-nightly" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-22/rust-std-nightly-aarch64-apple-darwin.tar.xz"
        sha256 "d6ecb377512823e3474087cf65641628b29570b0f7f07d200ff71c6871d9f2aa"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-22/rust-std-nightly-x86_64-apple-darwin.tar.xz"
        sha256 "55ff143573fa86d2da5e91b23a5a07bb81101991802016a763c032c765fc91f1"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-22/rust-std-nightly-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "9b8077310b0fa422d1173306b6f248122f979a718661e9f687476ea0e4c6d962"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-22/rust-std-nightly-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "a50d4ba9301558bd0a53c712d728b3c5dbf2998f1d4b3b9be126682f18f62bee"
      end
    end
  end

  resource "rust-src-nightly" do
    url "https://static.rust-lang.org/dist/2026-03-22/rust-src-nightly.tar.xz"
    sha256 "5128115315a8f83c632273b9a8f30705221bf78fddfd14c3233a76d688b917ec"
  end

  def install
    llvm      = Formula["llvm"]
    findutils = Formula["findutils"]
    ggrep     = Formula["grep"]

    ENV.prepend_path "PATH", llvm.opt_bin

    # list-licenses.sh (generates the system.licenses table) needs GNU find/grep.
    ENV.prepend_path "PATH", findutils.opt_bin
    ENV.prepend_path "PATH", ggrep.opt_bin

    # Assemble the pinned Rust nightly toolchain from the vendored dist
    # tarballs. Each tarball ships an install.sh that copies its component
    # into a prefix; the result is a self-contained toolchain directory.
    toolchain = buildpath/"rust-toolchain"
    %w[rustc-nightly cargo-nightly rust-std-nightly rust-src-nightly].each do |name|
      resource(name).stage do
        system "./install.sh", "--prefix=#{toolchain}", "--disable-ldconfig"
      end
    end
    ENV.prepend_path "PATH", toolchain/"bin"
    ENV["RUSTC"] = toolchain/"bin/rustc"
    ENV["CARGO"] = toolchain/"bin/cargo"
    # Keep cargo's state inside the build directory.
    ENV["CARGO_HOME"] = buildpath/"cargo"

    # ClickHouse's PreLoad.cmake hard-errors if CFLAGS/CXXFLAGS/LDFLAGS are
    # non-empty at configure time; it manages all flags itself.
    ENV.delete "CFLAGS"
    ENV.delete "CXXFLAGS"
    ENV.delete "LDFLAGS"
    ENV.delete "CPPFLAGS"

    args = %W[
      -GNinja
      -DCMAKE_C_COMPILER=#{llvm.opt_bin}/clang
      -DCMAKE_CXX_COMPILER=#{llvm.opt_bin}/clang++
      -DCOMPILER_CACHE=disabled
      -DENABLE_THINLTO=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_UTILS=OFF
      -DRust_RESOLVE_RUSTUP_TOOLCHAINS=OFF
      -DRust_COMPILER=#{toolchain}/bin/rustc
      -DRust_CARGO=#{toolchain}/bin/cargo
    ]
    # ClickHouse embeds the linker path into the binary (system.build_options).
    # Without this, cmake finds Homebrew's `ld` shim and the shims path leaks
    # into the installed binary, which `brew audit` rejects.
    args << "-DLINKER_NAME=/usr/bin/ld" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    bin.install "build/programs/clickhouse"

    bin.install_symlink "clickhouse" => "clickhouse-server"
    bin.install_symlink "clickhouse" => "clickhouse-client"
    bin.install_symlink "clickhouse" => "clickhouse-local"
  end

  test do
    assert_match "1", shell_output("#{bin}/clickhouse local --query 'SELECT 1'")
  end
end
