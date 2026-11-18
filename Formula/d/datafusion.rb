class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-55.3.0/apache-datafusion-55.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-55.3.0/apache-datafusion-55.3.0.tar.gz"
  sha256 "94e460e7ca1434d8d50a9efbb3fc8dfa2aa7b9ff19759cd733be03e808e9802c"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf03aa37ace4a7e175cd454b6de1a7a897d1dfa43fbbc64f70fdb93d128ad945"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec882aff6a2e1700616639911bad5466965c023057e4a7795ae5db383709e957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50a229a82e471376adb1fdbd7e2add6b508af31081bcff16f57f9b3c2305575d"
    sha256 cellar: :any,                 arm64_linux:       "a5e24fb5f693f94426dc3695cb5e04109e14e6946063020aea8f7ecdc2adbe1b"
    sha256 cellar: :any,                 x86_64_linux:      "379aca28e38e5db40b661621dfeaf8775810322db60d284daa485bcbd16e40b2"
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
