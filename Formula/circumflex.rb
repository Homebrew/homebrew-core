class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.1.2.tar.gz"
  sha256 "99dab786e97bf2c23da50ffcc4fa926a7fc9f6f9d1221747ba96bea2bf2c426f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde9a50459dd734d8abfc214c74c4040602008a636a8e1e98578d33bcbf85b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde9a50459dd734d8abfc214c74c4040602008a636a8e1e98578d33bcbf85b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cde9a50459dd734d8abfc214c74c4040602008a636a8e1e98578d33bcbf85b15"
    sha256 cellar: :any_skip_relocation, ventura:        "55a56eb8faa4009d8ce2048f88ad35ae19b189d3e0db09267f6e818e84e46311"
    sha256 cellar: :any_skip_relocation, monterey:       "55a56eb8faa4009d8ce2048f88ad35ae19b189d3e0db09267f6e818e84e46311"
    sha256 cellar: :any_skip_relocation, big_sur:        "55a56eb8faa4009d8ce2048f88ad35ae19b189d3e0db09267f6e818e84e46311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867f536222b80d51c3403cac04b7a036f7a8bc50d7d42c6f20845635ef63b710"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
