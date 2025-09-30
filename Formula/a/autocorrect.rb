class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "cb9f5bfcf81cf1e0c799e87897aa33e949996a319b16048262bec2d049491666"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "946fa2d537749bff4a2179f3a73e1d924e8477d0fdcc6f8c2b1bf080e7ca3e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018cb56bf370671a5eb9b919530988f058d045d8fabbac78be66bf21a390f1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0eefbf393015ea7bddb51e7b80af8afda631a82ece4251d144f7f30b2d3c4ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0cfccff53a19ddb5433392b6932f3a3ce17c590939ff740a62e85d6d4156d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b89cffa0a816b5182ecb1b4c11165cc430280b25d758540025f0b118a7dbadbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77928733439e82b8a24c00e80af5678dfe69f0595ca7111c5be815a2006e6caf"
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
