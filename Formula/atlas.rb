class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.2.tar.gz"
  sha256 "c295db029aaa11e6ae2b2db477c90674e1261f4680f75e97b90525385a33bfbb"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395ce14bb295e03c619b5bcffdf7a03603b9326db46398c3a4d7cf87664a71af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4067d1dcd85d04c1ef73128169f6d10512e081e7835a438e7f14387fb7d0e22f"
    sha256 cellar: :any_skip_relocation, monterey:       "721d211d17c062e88a841c25661cb25006b43a1720e2702628cac80426b56e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae93dc158e914e05ae707146d4430ffd4c3d14db97e4703f386e73b835b36008"
    sha256 cellar: :any_skip_relocation, catalina:       "696d19da2f644b92f4ae407fc22486f23750e505d82cfab0d5d5647ec3f48864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53b6accd57d6b4e1f86151c273247dd63f7a72d058e3fe21955dc0033e75b1fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/action.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -d \"mysql://user:pass@tcp(localhost:3306)/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
