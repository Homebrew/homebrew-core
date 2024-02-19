class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "33b3d00c3830c32927f555bf75ddc4d37ef7ee77b9ffda0e5d46162c4ffd0c9f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ae74cbba7374e94f49571055d34b115dc7386e1cae18ecea8fc9f90a58abd9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5152a42e49a1bd399b3707318f7970f1274fdd99c1e2e4e9a3e8e4e868e47072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b6431c3dd8e831f5cc1cb1fa4caf624b99f53eccb3869847207dd73562b5d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e73205d29f7a0b00fe6b94a32aa7dd93fa9e601670fbf24e4264572195d2fd88"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd881c55cab32c6af2ef8d40a2e4223b2f1a3bebe9636d77fbf7cb9e29370fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "9b1f868308182cc07476c1a63a8d0feefcee3a2fb232c0f31423cd185e0d2587"
    sha256 cellar: :any_skip_relocation, monterey:       "a4b51461588898026621ccf8416c681b9791dfb4b2e772f5528433d9304abd4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "58f860c68a2072aa40fd625254efc8ff10c4df89df04b9c2095789af33b5c0dc"
    sha256 cellar: :any_skip_relocation, catalina:       "8c9038caa1cad85d0426367d38315d3c4726b2a2f4159ad3f8724e59b0cae448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038efdfe697dea88af0498c07d231af34b5e553322fc3da54fca5b1c03246025"
  end

  depends_on "rust" => :build

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  on_macos do
    depends_on "llvm@15" => :build if DevelopmentTools.clang_build_version >= 1500
  end
  on_linux do
    depends_on "llvm@15" => :build # for libclang
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  # Backport fix for build error with Rust 1.71.0. Remove in the next release.
  patch do
    url "https://github.com/mimblewimble/grin-wallet/commit/0b491fea0fd5aa21fd28c171ed775e70f0877661.patch?full_index=1"
    sha256 "ec3b485062135c7a09ca4c5cf6bb9a6de29a0bb60850d5e7d4a7264f2945c966"
  end

  def install
    bindgen_version = Version.new(
      (buildpath/"Cargo.lock").read
                              .match(/name = "bindgen"\nversion = "(.*)"/)[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib

    ENV["CLANG_PATH"] = Formula["llvm@15"].opt_bin/"clang" if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
