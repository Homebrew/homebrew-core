class Dnsmap < Formula
  desc "Passive DNS network mapper (a.k.a. subdomains bruteforcer)"
  homepage "https://github.com/resurrecting-open-source-projects/dnsmap"
  url "https://github.com/resurrecting-open-source-projects/dnsmap/archive/refs/tags/0.36.tar.gz"
  sha256 "f52d6d49cbf9a60f601c919f99457f108d51ecd011c63e669d58f38d50ad853c"
  head "https://github.com/resurrecting-open-source-projects/dnsmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62d1f525a5c4d2770b488d65670cde33d377a460987e5e0568eea506b592ebd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb47816e6f0177b5e7a7358540055bf5d0346888bc921f6220ebd2e4a15cfda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af20d1658eb8b3f6191712debd39b3ab21afe033da12fb1e6a94b413f17b1d84"
    sha256 cellar: :any_skip_relocation, ventura:        "4c3b82bafb59e5ad12ecb2c8233f54bf9b218728e453aa9be75f42524f125cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "48eeee1b5697a45f09c625d67cd2780964e4183c94d9d7a667d267c0b56f2359"
    sha256 cellar: :any_skip_relocation, big_sur:        "194967d9aa003034d0c6e8f917cc0adffd5dff7715e085f3c44521e44afa3fb4"
    sha256 cellar: :any_skip_relocation, catalina:       "de4e15536fa71c6bf75f0821909002652eaf6b7c8a7d25c9229a85edddada4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165264ad85acecb8f79932782e3e0a1eba9110462ac627379ddc3d07ef4190b4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsmap", 1)
  end
end
