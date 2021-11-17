class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.0.6.tar.gz"
  sha256 "1728c341b147388fa8e60784c4b3895391be25f1e2e1b1cbb734329be7603693"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a0243c704510926457a5eb4b4b3d8f301582424c5fc44ea0fe155c4fa3ab75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7377ed366bd992706f59143c8e471cdc0cf3a69b9c440e2db3be73f02ee7802a"
    sha256 cellar: :any_skip_relocation, monterey:       "044a65865410e206516df42534250b0ceaefa7a4dc036b7ed0eae788c1bd1dc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e07435d1b92a2249a588a6937a153cb3bc8e35ca3cdf137ed5d181242a1c8c41"
    sha256 cellar: :any_skip_relocation, catalina:       "0e7265809d066b9c6d6d1e79b320038307b7b7f666e9e3bae6324a34bd58b357"
    sha256 cellar: :any_skip_relocation, mojave:         "8ab1292a808320aa1223f50d9975749a58eac7c579cb5ecbfbad0bbbcbfcc5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a7d71eb5b940fbac4e1eca4cf3030804834ddb57f5e8c0724a7cf3e20da6c7c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
