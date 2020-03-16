class Hmm < Formula
  desc "Command-line note taking app written in Rust"
  homepage "https://github.com/samwho/hmm"
  url "https://github.com/samwho/hmm/archive/v0.2.tar.gz"
  sha256 "4e2d474d2eb70f313ef6a97a5f392310e0317be9f7d88d46ddf5fe9b9e6a1910"
  head "https://github.com/samwho/hmm.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "", shell_output("#{bin}/hmm hello world")
    assert_equal "hello world\n", shell_output("#{bin}/hmmq --format \"{{ message }}\"")
  end
end
