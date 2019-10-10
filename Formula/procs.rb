class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.11.tar.gz"
  sha256 "ff84d26e4acfcf2a904745436dfd939d9f66903f86bfdc1bcffed366a0461f80"

  bottle do
    cellar :any_skip_relocation
    sha256 "76a5194ddb96b77457970ba85a0b01473ddbf858ce5deade9cadd995b73fb6b8" => :catalina
    sha256 "ebb48586e4e7d7609828a748dde28e4428afc4328162c6169359003e4eec9e1f" => :mojave
    sha256 "d4f87479c8aa4c37abf06bcccda95addf5fe5f3bdc6f572dc38c3542edbd638e" => :high_sierra
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
