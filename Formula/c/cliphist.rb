class Cliphist < Formula
  desc "Wayland clipboard manager with support for multimedia"
  homepage "https://github.com/sentriz/cliphist"
  url "https://github.com/sentriz/cliphist/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8d7dc7b4495e5812b5613274c250ba5d3900933d78888ce7921c01247f191cc8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0d341b62780cd1e692c0de243c81c94c99e42efbc86a6c1708f93d86b33e57a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b8468051b27d2b1b30ffa0f20208d14c70b21aa708709c6e6ea50385320e386e"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "echo test | #{bin}/cliphist store"
    assert_equal "1\ttest", shell_output("#{bin}/cliphist list").strip
  end
end
