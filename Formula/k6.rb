class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.36.0.tar.gz"
  sha256 "835e84e52eb40a3ec6297bdea5937fee74ba30a8ab5db8e0600c81e48af24848"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5631dea2fcbc3123917e9dbe5422821ea22531d2c2b6a3e1e7361042b23e913f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2477ce7802131a835ef97796d8b63cef64773ed142596fa67107f64c4dccabfe"
    sha256 cellar: :any_skip_relocation, monterey:       "becfd30c3ccd73eadc023a40b31a1f48e1cd1471f7a97647f084e1786f2141f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e43488892ec5677aeb1f105ae9097e7cbab728051c541e19ccc093f3a168d97"
    sha256 cellar: :any_skip_relocation, catalina:       "b89dc3b9ad08f484ab674dd71ebd09147b5d942d5581ac0122843884d8665b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb180989175b4b757d7a671bfa531c6bea491d2787b78edf444aab7b365cb4cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
