class Starship < Formula
  desc "A small command-line note taking app written in Rust. Notes are written in plain text and indexed by the time they were written."
  homepage "https://github.com/samwho/hmm"
  url "https://github.com/samwho/hmm/archive/v0.1.2.tar.gz"
  sha256 "968bc9f9fa54b4935200754b0096e7f55b4db16f7db118807071535668015f72"
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
