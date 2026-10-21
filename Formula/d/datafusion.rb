class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-55.2.0/apache-datafusion-55.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-55.2.0/apache-datafusion-55.2.0.tar.gz"
  sha256 "54b40ccacf006ad5967b7d398b5f7e111a682c4d6f9a519c929ab0f02da0f176"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ab5f9e4296f71c502ec8f12e16986396497ea176419f1d443249e94b81cc96e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c57b8a928455959805415ea96f88d88090bea60ab47b1c7d8153c5ec106dd6c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be84edd02726e6bdd14585ad6129753b3b82e2923afa0f51733729a824f40489"
    sha256 cellar: :any,                 arm64_linux:       "16e609b22354759aba28d527a82ecf190bc445d593217659d0431d77f1f64093"
    sha256 cellar: :any,                 x86_64_linux:      "a9fd52db40f5377a91daccd7933a2bab43cdb54c71b2674c015f0cfd96221108"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Avoid OOM on GitHub runners
    inreplace "Cargo.toml", /^lto = true$/, 'lto = "thin"' if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
