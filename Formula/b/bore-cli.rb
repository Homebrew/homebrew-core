class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "https://github.com/ekzhang/bore"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "8da3d83647f7f1159553e66d28a94c944ffc55f44962340d3f8046fda1528533"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7448f06ca26474a1ff796dd270d1f364a5eab6a9d7ff70fed44388112c2cb3e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "920e27d242a6dc0046cc662efc7068f2ae2fcc69c4dbc1540649b62a3ddd05c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aa561f03bba9d8b9b130839de74f1eb296e878d008a81b9e458ca38b3ed24f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a754b67136235aba2145c621ea7f909a59590ca1105b8d73c00e90d6b19ab0b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca5eb6ca68f25774ba941f9fad86e2528c81a4f84f88ccd0adb00f70ca886ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "224c80b12426f9abbc8e8eb321d57d31975619097e21f9ad63d3f857bf783579"
    sha256 cellar: :any_skip_relocation, monterey:       "2439254d8e7023678061ea97440b6b05227d2bc7383a1e017eb81c9960e68b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b41e13809ef0fbc798879444f351d5c15122060706306448db6ad1a1635ca47"
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
