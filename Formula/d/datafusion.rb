class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-55.1.0/apache-datafusion-55.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-55.1.0/apache-datafusion-55.1.0.tar.gz"
  sha256 "9399749c87b48d91de8352ad4f30ad418c4d4fc1a55aed2dee3c0aaecb4c6a04"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b44223e69089593f13d9cb131ebce3dd4d2df598ac165e4e7455ff8c3081dee8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10ef0eabb6145af407a7b465430dcfb4d41686a5ea25b9a6394f20c13c6e3e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47795a393c76a7f7f147d70ec693b0cab4ace9439f868585e4860f60248e5cc0"
    sha256 cellar: :any,                 arm64_linux:       "18c9dff2b1d529535d0c4943a6039692c10de6df04b530cf48ecc63b3b79307c"
    sha256 cellar: :any,                 x86_64_linux:      "19a5aceaa71169a076fa7d0112fab90bfa472622c191f590e13b6a606a4669f3"
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
