class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.3.tar.gz"
  sha256 "ba898331d76e266ae3af4e5eab5c6af30ef004c133104fec3e0bbb9497f5c70a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ac00b284c272e8bee9a5ce9df02a1376ee27ebe2bf1b9cbdbb3fd8adf837dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f42df2bbcafa3958ded1d4a28fa34b5f5eb8a087637510228dff42744eda9ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "6eebcb33d48b2b87b50d2470f22cedc4fbc0f6129763328369655252903795bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0c7deb6eb0dfa77ea5cf29af222adaadd197678ed1d90a827a144161eda1c94"
    sha256 cellar: :any_skip_relocation, catalina:       "be676c2fa0e21111154ed2c2df5731923bb2934d249a315853639e1bf3562054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2163d8979f2896efb2ebd22dd094d3ab362a392bed572bcf87b2cb99c1fffa73"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

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
