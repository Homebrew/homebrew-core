class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.7.tar.gz"
  sha256 "3ddf978dd97df76675f48a45b3e5eb7f6da33a5941f88115972e4329f7efbfd0"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a32975eb17338ddd32d27288bacf1a167f4a1e6254c3b0202e116e31bff04f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8be7b381be98fedb54e3a49ec4c544b8f6d5cf3ed7ff9b4f239f7f8bdaca564"
    sha256 cellar: :any_skip_relocation, monterey:       "41770680e42f1c089fbd3f2f4b22d87f7010b436d085b7111d30dab9b87e5cb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "688fbc5a65e4ad1a9462f7eb8fefe51e9d6a726eb9cf409d65c9ff355f626382"
    sha256 cellar: :any_skip_relocation, catalina:       "de221c51001fcaf3403b1336064717e820f8a4bfe6b60570ed4a308d94cb2a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12d835c9a108f7d56bbfb046b41d5cb994d0dc3b35e96b2dc65391878cdc806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
