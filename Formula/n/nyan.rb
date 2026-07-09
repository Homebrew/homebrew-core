class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "49b1245d87868f18b7577ab646d458fefc608f7eda27ad742648bdc69083a107"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb1a9c0d3401c9b38910512337e2da0d0e900bd84cdf7abefed7886ffae35aa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1a9c0d3401c9b38910512337e2da0d0e900bd84cdf7abefed7886ffae35aa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1a9c0d3401c9b38910512337e2da0d0e900bd84cdf7abefed7886ffae35aa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af10633b9258735c8d2d8efa27e22a3c0b80b61d6aa1699fd4700394ac484cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aa51734abb4bdd3cef2886b4089ed0f7d3aacbc67a7c1c4446103c52af32e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bcaf20f13faa82c1bd1e19d00247813ee428c76f834d8b80e69d6edd6de8f61"
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
