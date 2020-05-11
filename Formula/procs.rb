class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.3.tar.gz"
  sha256 "cbb31a3a94b0c697aeb687f103c9128b3fed006cd0c802fb47f5c67415c32181"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa3d5fdd125d3f6e9c300af339c46a604769d7dbe5ab17e6fb9585410e55a9a5" => :catalina
    sha256 "5c91e5a345d3a1e19d2e574c3f9feae9b5a0d4d8912c0f9bff8443909139d75d" => :mojave
    sha256 "9199cdba65a95ab95eeaf6fb5f4344feec45f7c06f8ef39d460c781869a76fcb" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
