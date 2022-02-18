class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "71095b2c0319b29448e5554054c3fb65a35a1f62537970f482e073cd671354b6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08111cd36e0982a48174dc3e1ce11e59152b73849024691d6d3704f54bc43441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08111cd36e0982a48174dc3e1ce11e59152b73849024691d6d3704f54bc43441"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f62f1961fd3ff664998fe3efe921324a9254ad0b87250c029406b273a83286"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f62f1961fd3ff664998fe3efe921324a9254ad0b87250c029406b273a83286"
    sha256 cellar: :any_skip_relocation, catalina:       "e2f62f1961fd3ff664998fe3efe921324a9254ad0b87250c029406b273a83286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b9b740754c9cbb0e817c523406acd083982bb7a4328aa50bdab4bab10811a4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
