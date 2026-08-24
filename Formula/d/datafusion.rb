class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-55.0.0/apache-datafusion-55.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-55.0.0/apache-datafusion-55.0.0.tar.gz"
  sha256 "ed5c467bfd578a3379a863cc97160fe9e2e8753b193fa14b79eb32ca13861057"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f052826f9e02260f0f361ce4b6af42ddebbfe41a57026f4aed4b2c68365b496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8096b8c2df2d744538754d8aded0981a415de12a12af6e366c8a498cb8532949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ac4bdc3634fdad7bacb5f79bce3a0e335f94549860db6f5a1335622b134a6a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6c70958c87a79273e1388259c45b6fe78719b585f2ca126f438124754fb06fa"
    sha256 cellar: :any,                 arm64_linux:   "51405bb5f038412960e7bff2a1efaafa7f6b8f666cba621f4bbcaaa863f82aca"
    sha256 cellar: :any,                 x86_64_linux:  "183ed666caa72b9a6208ada817dfdc100d48f305c5f355f1bf2380800555bd8a"
  end

  depends_on "rust" => :build

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
