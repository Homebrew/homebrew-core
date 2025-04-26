class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "00a527fb3d22ad5c780b119fa07afa1b57910b1aa664b5ad426db29582f118e3"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a88eae586f0f550edefdede3dbe5eb4dafe1494ad6ca1c3854717ea2f33a68a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d3015eb4dd65b8c251584b09b919bc7027f7801b7b4a237c099da132740134"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86cbfe55e27a8a5f04f91e5fd681b669ff77d803fe527d883676c6671e1a2183"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddb554c49794835e4026c08f6deaef40c6d020ddda11c401bd11c7f55236ad30"
    sha256 cellar: :any_skip_relocation, ventura:       "5ea5145d04cf1280b22be95c9c17d6cef7fd2a963877ff5f246278f0253a8bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "546055076d28825ed7ec74446178133bf8e131ef6c8700fd9f726cbbe1ee0d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a3577419fc262cc767dba1ce37cbe764f0861ff4ac915c193cb32a71cad023"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
