class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "72d3b7cb128c4eee732a299d85c518b48f7e8b8d4a8da875f80e99002f5488c9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f1a5c76c36271972aec753eecac8fbc43bdeaf0650274fdba8c58b82743dc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4f1a5c76c36271972aec753eecac8fbc43bdeaf0650274fdba8c58b82743dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "453c604ccad1fbe8f5bac3fbba382981d95f57f6f943756926d91d06a5b0e59c"
    sha256 cellar: :any_skip_relocation, big_sur:        "453c604ccad1fbe8f5bac3fbba382981d95f57f6f943756926d91d06a5b0e59c"
    sha256 cellar: :any_skip_relocation, catalina:       "453c604ccad1fbe8f5bac3fbba382981d95f57f6f943756926d91d06a5b0e59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b89febfe151c643a79e546d95057babc3193e29c3d87f5804895e6c2923549"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
