class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "f3ae46062d2d9dc928433b32000c08954df89b731b7f72a764aa9a97cac8594e"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9da9655d70408761e5aa924baf03a3852652a27edcf298fd51dc10762ed44808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a7cd6c50399b7552e9e09688134402d91dbe3b890ca57a36ed2e63af55ef3cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e72b6d59d0c50798dc795cfa07bba4401c63037742695075c840c764ca17fc93"
    sha256 cellar: :any_skip_relocation, sonoma:         "38855cf21efb66d35b5b5b7cbbb4ebff5e0a8764d6f4c2b79112019dac51a7eb"
    sha256 cellar: :any_skip_relocation, ventura:        "2f3012ca3acae5930d8bc370142e71d1a0c15c5b3a6195e537fcbbb1a9935578"
    sha256 cellar: :any_skip_relocation, monterey:       "89eaa421c80c23fb5882ed345559f2f6b38a9bcb9587687b371c0baaeae83716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ff7decc19d48164751b186799d04fe7ecebcd476c222911c1e9e66e49d5305"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
