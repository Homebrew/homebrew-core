class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "6ce344a1ee870e618e15ae17a85497abc353bdfb30a8c1ddfcea5735aa17adce"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ab28edcaca037332f72300890326087494898d57b53ca9febfc6c938b46f375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162d4a673fe0248ab566149c72f5285581b5907031405fcb3388a3f8eb8f60ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162d4a673fe0248ab566149c72f5285581b5907031405fcb3388a3f8eb8f60ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "162d4a673fe0248ab566149c72f5285581b5907031405fcb3388a3f8eb8f60ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c340d9b586c066ce42ca87bb7dd4627e7d299e0b0e2a83f5d7e9aaa563a42f84"
    sha256 cellar: :any_skip_relocation, ventura:       "c340d9b586c066ce42ca87bb7dd4627e7d299e0b0e2a83f5d7e9aaa563a42f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5f2b779d971396b9bc699b7d428c377c67aaa8af9c650613a4ae72a782e85e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end
