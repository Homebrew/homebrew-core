class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.114.0.tar.gz"
  sha256 "7bff1253be3a906c90fb9fce945ed9de282af8fddfe150ec0465bf17305c67e9"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90ca498f718cbe3ec7ad2b1b0441e87e32bbb1efd02df89c37206c4694f85663"
    sha256 cellar: :any, arm64_sequoia: "b29d74e5640a94e5e3402969bcd3ce1964d946e17cbed48b49780209ae5d0138"
    sha256 cellar: :any, arm64_sonoma:  "6d8636f20d68746a9a64ecd0ab288199c7be201a29e88803df7df6c01f673485"
    sha256 cellar: :any, sonoma:        "6083759ce36b74e76c353227100ac68b04ec3977d55f28b910f89101e40f9ddb"
    sha256 cellar: :any, arm64_linux:   "b93cf1cb8cf49904c0b7007a9c740546fd3dc45bf119a8b30771e9601fbead1c"
    sha256 cellar: :any, x86_64_linux:  "14401dfdd146fd4b2dcded955864851864d10a45c269b04a969f15c8662c3ead"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
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
