class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.5.tar.gz"
  sha256 "3235f97e51a7bf228b31f1379c4a51e3d837193060a766a443f272f8434bfabf"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbc2af822ea36db0ccd4d3558917aa8181f7fa50bde955525e0feaf945dbb956"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a191af7749b700fd6e6c005410a52d6aac38012acc3c8a12c8414ae0f0980a1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67741ab4de1c00bcb83bc1531b4c5898e9b5aa35cfbc568643032719c181b72"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2b73df956b323eaad6c8a4a4403570608f9a31fb4f394011369834ca53af15f"
    sha256 cellar: :any_skip_relocation, ventura:        "acf2d7cfa8ec8f3e9ad6b199496857db33983644519511a496a7a7f238f5eaf0"
    sha256 cellar: :any_skip_relocation, monterey:       "367e9b6107f7d1f2857a3607d6dcfe582669fb9dfb219f7197fc1f5023406393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a81b1d1469b7a6de175d3514248b1da2d4aa1e0f7f8ab201f33c68c5a7908f2"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx article 1")
  end
end
