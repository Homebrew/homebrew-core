class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.83.1.tar.gz"
  sha256 "a08baef4e487cf200b14cd4a8555110106a947ac439ad8e2759f5ec52c8f9656"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91ea0c70d7a016588833b5f63004c600f125d277711899155e7c73e91b62c8a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f984563bc216ef1b72cc2935df55468813bb0251edb772981a1d7f51a730554"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e16b187c2496515f4f5178d185ffab16b44cf3331b527c5fb9bd97d85d10f48f"
    sha256 cellar: :any_skip_relocation, ventura:        "f09522bc63571bcc94f983c7823643b4ad663aadc6c05c67aecec3269229458a"
    sha256 cellar: :any_skip_relocation, monterey:       "67b22c8d03f4000a4adaba3dc76b44ea7598da4cfe1bb592dd21256f2eabbac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "babf25a364f434e465793275155afceeeb9251da12a17242b7d9e7ba387f4887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c6a29cecc5faa32daf65a27d464d71c4685e0b3193739412247f59707457a9"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

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
