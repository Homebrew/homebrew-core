class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "40bfda5e3f8daf7f344977be45d54fb3cf1630ae329ed046cb161054bffc30e6"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d32b25a423bbc95b778c170a847231b8fda8de3857c740d9516fdac6049b9a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d1238108d69bdb14a6756972313b06d6d22b2a8a1ca477c68d7ad11f90fe328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4c75b9b6fbfe1ea72d5b77bea0806bfcd74770297a251771638a6d8c9a5ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28e2f15fa7969d522544dbd8ba26183568491e483974ca4f76e1c6ab4869846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae491644ce862ba837d551063c15e8d8efcb740fe536726a8c7f52ee686adadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43608a2e6a8200adc51c21982b1ef86a27a6c22d74b50242834c589f3eb8841d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
