class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.4.1/git-lfs-v3.4.1.tar.gz"
  sha256 "89acbe51799c5d7bdf6d8e6704fcd1a07735ee7d1ed67a0bc646a5d9a9d1099f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63461c3fbf6ddab9d90c8c6dcb51748a68c4446f222709b970dd688dd78a77f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef15a9960b5d1c3b733abdd1b5d96627a2e283f4692c72d715f847077384113d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51eedabacec42fec1a26db689a47e2be2347ec8fc3850842536ae1fb8a511a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "f88a76628284d2123bf6c212bae1df421239fa785355bdda213d1e03be0bf76e"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7d60bdb25b7e502b20cf7f14c290952f555b1381109389203658cc3c5533e3"
    sha256 cellar: :any_skip_relocation, monterey:       "9f4760a2174790e1df7c6b12d37dd86389d0eb78eb03c542143c16c34db67175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fc232d300970630066e73e46387fd1ef0596c78975b73e7fae0a1a71c04d974"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

    bin.install "bin/git-lfs"
    man1.install Dir["man/man1/*.1"]
    man5.install Dir["man/man5/*.5"]
    man7.install Dir["man/man7/*.7"]
    doc.install Dir["man/html/*.html"]
  end

  def caveats
    <<~EOS
      Update your git config to finish installation:

        # Update global git config
        $ git lfs install

        # Update system git config
        $ git lfs install --system
    EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
