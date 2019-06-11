class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.6.tar.gz"
  sha256 "ee045e780cfd76fdb49a1011c46a7a222d6e6af9375600554f94eafb3713812d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c85d47f451906c27a29220941d1616521bb61c50a43299551f889f62fac5739f" => :mojave
    sha256 "3529d7208c1343deff6ab969b98003c0cadbca1d8fdba41228c1a0dc5d64ecdc" => :high_sierra
    sha256 "ec5ecc9a0db3fcb83684fb49367713f36f485f038f5fc9e9b35720cd80cd3aba" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
