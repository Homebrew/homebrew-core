class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.3.tar.gz"
  sha256 "d491a8de54c0c68b467176f3a538f6e01c809e445cbebff3db3ed8745196871b"

  bottle do
    cellar :any_skip_relocation
    sha256 "28cedff0de29f6fdbe8c8b4663b61353605f24bd616415aac24d66ebca5b5716" => :high_sierra
    sha256 "0da3c8df0ebefb4f229ff8cfeef1d0a623c4f2759ba9bb5111a9df5fb63a8e7b" => :sierra
    sha256 "21db5b8b51cd05eef099d4566dd107530281c28fbaf6315eea12950f8263e0a9" => :el_capitan
  end

  depends_on "go" => :build

  def install
    begin
      deleted = ENV.delete "SDKROOT"
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    ensure
      ENV["SDKROOT"] = deleted
    end

    system "./script/bootstrap"
    system "./script/man"

    bin.install "bin/git-lfs"
    man1.install Dir["man/*.1"]
    doc.install Dir["man/*.html"]
  end

  def caveats; <<-EOS.undent
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
