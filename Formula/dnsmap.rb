class Dnsmap < Formula
  desc "Passive DNS network mapper (a.k.a. subdomains bruteforcer)"
  homepage "https://github.com/resurrecting-open-source-projects/dnsmap"
  url "https://github.com/resurrecting-open-source-projects/dnsmap/archive/refs/tags/0.36.tar.gz"
  sha256 "f52d6d49cbf9a60f601c919f99457f108d51ecd011c63e669d58f38d50ad853c"
  head "https://github.com/resurrecting-open-source-projects/dnsmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb47816e6f0177b5e7a7358540055bf5d0346888bc921f6220ebd2e4a15cfda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af20d1658eb8b3f6191712debd39b3ab21afe033da12fb1e6a94b413f17b1d84"
    sha256 cellar: :any_skip_relocation, monterey:       "48eeee1b5697a45f09c625d67cd2780964e4183c94d9d7a667d267c0b56f2359"
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
