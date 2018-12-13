class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.6.1/git-lfs-v2.6.1.tar.gz"
  sha256 "df7fcd3a72f3b8916b2d9a591f1435ea7479f397257508c335cb5ba82c040f4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e73e7554c4b45bc1ba95fb64e597457c97f90179fe02ca5dd34e0f22112ac19e" => :mojave
    sha256 "0daf04ca0a32e208be0e6df07c42a1ab049a3e50c962b04ea650a626a97920bb" => :high_sierra
    sha256 "9eba8835ba9803e37f4f8e9215f98bd8cd1fc903baa47563d5ff195bc8d0060e" => :sierra
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=.gem_home/bin/ronn"

      bin.install "bin/git-lfs"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      doc.install Dir["man/*.html"]
    end
  end

  def caveats; <<~EOS
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
