class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.10.tar.gz"
  sha256 "3d3ecb85e985013b4494225eefffbec0eecdda236ecaccb287e2cc7bc32d2cf7"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db3ebfddeeef682161696623acaa9fb193c57d1778258a5f1c6edbd5abcfd19a"
    sha256 cellar: :any_skip_relocation, big_sur:       "efff9d9dc9ce7217ecf5c40118a7685ae8802dfc2e14c534f64f35820c48e7d8"
    sha256 cellar: :any_skip_relocation, catalina:      "21611774a8b8649eaefe63ad445bde7eb3372ee43e92d7d6aa4c9d62c43e212c"
    sha256 cellar: :any_skip_relocation, mojave:        "f78eec441bcbc81a01c5cbcb8cd5399657c373660ff1f18dcf2731848f6b615f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
