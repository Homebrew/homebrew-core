class GitXet < Formula
  desc "Git LFS plugin that uploads and downloads using the Xet protocol"
  homepage "https://github.com/huggingface/xet-core"
  url "https://github.com/huggingface/xet-core/archive/refs/tags/git-xet-v0.2.0.tar.gz"
  sha256 "551237dbed960265804c745d50531cc16d8f13fb31e1900c9c6e081bfab01874"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^git[._-]xet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a58ec542e60ca0a91d3198c7c05de33b637e0787c9d53932f95317cbd3b1cfd3"
    sha256 cellar: :any, arm64_sequoia: "5a02845141fd5d07067509faa2aae91e9ff9227060de06937382a1d65fc4dbcf"
    sha256 cellar: :any, arm64_sonoma:  "4f5e838f9c31a162598f1b5f199c33ac2bb1ae6ac26f53dad6d6db0e74ac42ce"
    sha256 cellar: :any, sonoma:        "cf348b67313860101f564006f6642c59ffd96a8cde43483c5d6fa37fdf0e8af2"
    sha256               arm64_linux:   "740715c7c15731533b6c4eed6beb2aac05c1c27affaccf48eca2e589ee24edc5"
    sha256               x86_64_linux:  "6dcef8b244c68e64b8559b7395bd32cb8182e42b25aebb9c2d986dcf0c8854fa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "git-lfs"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git_xet")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xet --version")
    system "git", "init"
    system "git", "xet", "track", "test"
    assert_match "test filter=lfs", (testpath/".gitattributes").read
  end
end
