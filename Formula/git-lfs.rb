class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.3.0.tar.gz"
  sha256 "ac386944db671c51f29a2a45740d0f09fab538ba5b94338853e7c2bff34fc30c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fb8112f5e047df543b075c60f94cc31b07768ab410f17f6fc7a3c7feac0cd7b" => :el_capitan
    sha256 "70b6f0f835174ce1e742d8624eeb571fe4cb0c78edabdda47db97cd484951aaa" => :yosemite
    sha256 "d906e4fb4c07e9b2f6f924f4d25c607a3e0060ace95cfad5711e33c38568e025" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
