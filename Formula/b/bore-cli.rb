class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "https://github.com/ekzhang/bore"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ab3175a6f304c7efdcacd0f6a0e4950f49eb31cb2a3ae9b4928c97ed8d03861c"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b6d41535558ab9df7926e6275f540ecf9774c443544cc5095af94f610729a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e9d9687655043674c052c222aa3e5278f46a8e80fd00913dbc5a620c29c526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73377f27cbaae4ca7fa474d7b3ebe4b3fe30e975ba37a23b852f92d43f1843ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bfa5d67bd3593a3f93b5e5699c4985bee14b37aeba172c9fdc03c02ea1b0bbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b722a8b975830007a221cdbff215e3ff127d80f30a9a734fc1a696c1843d0d65"
    sha256 cellar: :any_skip_relocation, ventura:       "0ca6bcbfa21ac2215828fc5f831ce32c4471dd03aa3ff9e617a7b4c3fc18106a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9169a3f8a0c759aa78466c1740cca29e9848cc95c1b4621cf6aa47bdf810e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642cb726161e0fa78e77642108e14fa502287262a7479998dccce2b042e2c2f5"
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
  end
end
