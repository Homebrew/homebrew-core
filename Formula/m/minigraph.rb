class Minigraph < Formula
  desc "Proof-of-concept seq-to-graph mapper and graph generator"
  homepage "https://lh3.github.io/minigraph"
  url "https://github.com/lh3/minigraph/archive/refs/tags/v0.20.tar.gz"
  sha256 "ef695e69d57bbc34478d7d3007e4153422ee2e3534e4f3fcbb8930cfaa5e1dc0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee16f2ce2ad02da0fc713ab8729719e5bd2bc96b375ea1e3e3723f99f1873495"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54c9d30b5a37fdbeab942ca198c4184a0ce43060b14ed99b606aab902551dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7bea2c11396264d7898bd6cf9f306efc4869a76f5299b00689c28fbf67889c8"
    sha256 cellar: :any_skip_relocation, ventura:        "58d39d6a61dfffa94f3b6e2724135778dc9670cfaf815e098d66f5b55177d124"
    sha256 cellar: :any_skip_relocation, monterey:       "7756134609a6075c3141796d125e57b481d538abbcb7c2fef094fb8c11de2ec6"
    sha256 cellar: :any_skip_relocation, big_sur:        "aec032083d7519d278f0571fa7d36f2fd14dcb87bd1841bf78181f6d3e5abb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5e56be94932f6956d48c6bebe7ac86020b386ea162eeb86d9f954e75f0a453"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "minigraph"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minigraph MT-human.fa MT-orangA.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
