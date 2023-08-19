class Bk < Formula
  desc "Terminal EPUB Reader"
  homepage "https://github.com/aeosynth/bk"
  url "https://github.com/aeosynth/bk/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c9c54fa2cd60f3ca0576cab8bdd95b74da4d80c109eb91b5426e7ee0575b54f1"
  license "MIT"
  head "https://github.com/aeosynth/bk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba9da92be4cfe8dda48401bbb076d70023b9b99c3cdd3ad47672e4b6e7b8b383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c614062d4ccbaabe39d7cf8e3983f3f755d44de3d31303c61f4580f8e3f37c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d6537ee4a045093a5a5806960a47115c3ae8a5ee445cc82381c173fe8ab9c14"
    sha256 cellar: :any_skip_relocation, ventura:        "73f86729257ae80b45e394d58937ed200b5e8ae4ca8444f7def776ab234f863a"
    sha256 cellar: :any_skip_relocation, monterey:       "07d149e5806bf6444300a9d066bc682f0f950af403bac33bd14c397e39cd52ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c13b4e9b99a77a351c9dc92739c2bcc5530fbd210bb09414185a30a7bd43b0fa"
    sha256 cellar: :any_skip_relocation, catalina:       "a6f81962f928165e9f0f039534678bf5a09c25a99156de7de192bcb7c738ab72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f338a07f8edeb7b1d72cd6075fb17c1a0a552915c045b56b4b480a5806c887"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_epub = test_fixtures("test.epub")
    output = pipe_output("#{bin}/bk --meta #{test_epub}")
    assert_match "language: en", output
  end
end
