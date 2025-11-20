class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.108.0.tar.gz"
  sha256 "5995c211411ad1d5dd7da904b9db238a543958675b9e45f5e84fbdf217499eee"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e0957b13e909b83d8561dab7b96c53a311cd48b1a93fbf472d2229ca6867cf80"
    sha256 cellar: :any,                 arm64_sequoia: "adb6f262df5a3f7a8e5ef6b0ae654ce1f0fecc264cb03d345a00b4c4660a1700"
    sha256 cellar: :any,                 arm64_sonoma:  "74f04d4051bc32f7148db3252d9fab2e59f1c46999dae2402249a24887b8d5fb"
    sha256 cellar: :any,                 sonoma:        "3eff4f5855ca571e33ae14d808f4555cbfb568a41032728c7d8a7e26d344fd43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b381e2cdceeb123eced1cd230b0135ee2806604c59037466e39dec7721fc06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b108eaab5085b5e152fe3d89ec41b898bc76c29194c63f203b4ae1c6cfc6f4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    ENV["NU_VENDOR_AUTOLOAD_DIR"] = HOMEBREW_PREFIX/"share/nushell/vendor/autoload"

    system "cargo", "install", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
