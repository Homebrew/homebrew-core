class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.1.0.tar.gz"
  sha256 "638e079aab661a8e4d886fd9d4ea728c5e4efcbf657ad4f5497ba39b91e91c08"

  bottle do
    cellar :any_skip_relocation
    sha256 "5655e4e40541c02ce91f945bf8fa90ae2d2d42cf3eb768c253965cafcd1a0c40" => :sierra
    sha256 "2f0ef9032fecbdfbc3201f53ee3ea4e951471d538b63b6a3e1c674fc55606d2b" => :el_capitan
    sha256 "3cb63ad49bbe936a446d7a4683f4dcb36cc7e3539409fbe595b8b72798c32034" => :yosemite
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
