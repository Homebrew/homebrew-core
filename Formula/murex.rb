class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v3.1.3100.tar.gz"
  sha256 "c719456e7b6b09cde046fa3e6fcab24fc9ea046ccfbe7028aae923a21db5356a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11cd55a8e6619b12fb59e175778c48932fbfdb546c9528f95c123d161528b663"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095373144e9fd62dbefb88cfca3d329eea5a3cd86b892a56bc9d2fcfb4abd1b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24ee8cc4a3ac5e246c3f5c59cacbfe44cc299a88370330a2bb2e57c6aa97f78e"
    sha256 cellar: :any_skip_relocation, ventura:        "120183c3be4e1719176c5c019d42a858338aecb0ff3dee2aae7af4e5667ed724"
    sha256 cellar: :any_skip_relocation, monterey:       "cfdc8babcc62bfccc0b18fc630465e0c73a87f635626467e66add94bc087f606"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7ed9c288ca9eb1665b185fe2ddcaf59979c09654cda4c0f7ba52f5fbd82fc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f0d58303957516cba92cf9d427a3fc79d5a416255fea90660b917959895de67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
