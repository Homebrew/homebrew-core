class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "http://bore.pub"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ab1f3e924ce8a32eafe842de0bb1d23eeeb397ec0ad16455b443206f0c9ee59d"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f244c0b291a30c7e04f446915b07f9ba185e1b0ce5b6741bd7b4dd61bacb8013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7396f546c8565da31d6ce359cecc561b55674057d2ee60f52b0c331adaac28c4"
    sha256 cellar: :any_skip_relocation, monterey:       "fce4ef7b3e7a96ac2b4efffd42a32dd67e08290eebe8d3b45960d8ef381a7bbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9781e5efc3fafaf45ece11b1cead8181ae74aa882c54b6311130cc1015543d03"
    sha256 cellar: :any_skip_relocation, catalina:       "b0e8e5d4fbbd2380180c766f80e5159eb0afe6588865dec1866471878d0d1684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03809afaa3b18fec475d48af05a2df6997bb8c3cc661f0cbc3577df82c76c363"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
    Process.wait(wait_thr.pid)
  end
end
