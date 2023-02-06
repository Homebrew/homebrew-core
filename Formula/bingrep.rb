class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.11.0.tar.gz"
  sha256 "3012aef73b3ef5e8b100824af0db2131f81771338fec5f9fe47dc71bf3782506"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76dcdbcfe00bd350f3a14d795bc1444fa3098988e32d92650ecfd405c0a10923"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2bd7d4c909c452800bf371c7ac0b0d574f147f578dd568072b868f49d9114c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "466ea3a1401fcedf6c69d9c983f690f8769b847d92ef816cc06f0a6f012e08c1"
    sha256 cellar: :any_skip_relocation, monterey:       "544fc47c2df72b0da53fbadd834695c35ef8a72f33f9ef35e2ce00b82fc752f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcdef9437d6c56760d5ce9bdb5bab910f790a3281ec908df6bef39324f4c65c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa0f7ec1fae9a347cf6243053b82b602b843687722b456c6484596fff8c67ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
