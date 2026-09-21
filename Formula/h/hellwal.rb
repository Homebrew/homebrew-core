class Hellwal < Formula
  desc "Fast, extensible color palette generator"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/1.0.8.tar.gz"
  sha256 "53f629f22bd80c95150fa8510c4c5f4969beec06bfd01ad33a5fdad3d56a357e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c878b9620f231a54aebc76e61fd70d8e86f56d52adb9624c5698d4ce5cdd6c44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf4242ff50905d089417461d5d5736fd017b089ea457dbe8b71804216b0c993b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5490782b0e56972fe9b0aeb3e0d2d182a644012f93ee777a99f151335752ab4c"
    sha256 cellar: :any,                 arm64_linux:       "b124d10fb5b5bd860b33fb44bd44ee9495f59acf48e20797ede02c642a965db9"
    sha256 cellar: :any,                 x86_64_linux:      "432792a355394a09a0f26bf0a2f1d07bb9e306bf587aaa8ca0a8bb6c37856942"
  end

  def install
    system "make", "install", "DESTDIR=#{bin}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hellwal --version")

    (testpath/"hw.theme").write "%% color0  = #282828 %%"
    output = shell_output("#{bin}/hellwal --skip-term-colors -j -t hw.theme 2>&1", 1)
    assert_match "Not enough colors were specified in color palette", output
  end
end
