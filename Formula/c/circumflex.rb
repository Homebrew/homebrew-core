class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.7.tar.gz"
  sha256 "421cb4757fe15b7d403a7ae5ef70c0fa283ee445b957f1689d68eaece1947dcc"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "62b89511568577c435bc481c50917d1ce6be38fe9783686269f209ff732150ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb7300a1adcecca4c7f342b5b2b80fd77f4738ee8ba837898cc9371a29f175bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a8c39cad6212319001b92f719cd052aa61296e2d979391430d5dcdaeaeddad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f533af5000f818611a7934c749f7171e7e317bcdf216f18508c38c8973920c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0d39d9faccabd8fed803f3c69ed479672e15c28b61ef2e5af12349ae070a408"
    sha256 cellar: :any_skip_relocation, ventura:        "4f9f2bf56d39d6e5e9478c051b07fdf686da2a688746dc1b2f0a4e496db49d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "6e28a94198ffb94ed0cf2c4bdd9f8187d7c77297b7d25e08857d85157dbb29a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b25b51f2bbf9a19b8df483220000d0244b6dbbafc9b1908f02982b549aac625"
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

    assert_match "Y Combinator", shell_output("#{bin}/clx article 1")
  end
end
