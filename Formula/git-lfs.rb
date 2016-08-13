class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.3.1.tar.gz"
  sha256 "eab3ae0a423106c3256228550eccbca871f9adc9c1b8f8075dbe5c48e0ca804f"

  bottle do
    cellar :any_skip_relocation
    sha256 "78cfa903a746fa4d86f8940ca6ca1795b71e4cc74922c2b2a0ada04130c1d783" => :el_capitan
    sha256 "ee5afe70f5628dc7b42f556d4b37fb06920f57f99d0e64a7f0c00316fbcc5922" => :yosemite
    sha256 "f35f8310f923a61bcc6c3798d7edadc784533ee9801f1d251a53c3545e215e94" => :mavericks
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
