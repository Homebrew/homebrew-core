class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-56.0.0/apache-datafusion-56.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-56.0.0/apache-datafusion-56.0.0.tar.gz"
  sha256 "89187ce4a9d6ea65e2edca2503b690e1dc5853c3ee3bb6c672a05bf9b1ecbbf3"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    manifest_sha256 "181f553b3686cb3ff682bef1f393d708b9fd924f27aea8886d0e8221af954635"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6cfe1c4e373395b49a10e8bdaf3d7444c3689aacb1a16bed395b91269577076"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "164bc12e058bfa1e08b24190445c4c791595a4e62cc9e8c61bc27b97900f54f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a172ce5e7825526d864c832e951121afbfa197e59f32767815a463bf3b0a5e31"
    sha256 cellar: :any,                 arm64_linux:       "06ceeb07a4fa701c11a7b4eea251e67b28eb8686b558efae51c1a2f93420619e"
    sha256 cellar: :any,                 x86_64_linux:      "42afdc033422022682ba3f06e2f86a836679ed187270bd77fa247065623884d7"
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
