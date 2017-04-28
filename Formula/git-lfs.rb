class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.1.0.tar.gz"
  sha256 "638e079aab661a8e4d886fd9d4ea728c5e4efcbf657ad4f5497ba39b91e91c08"

  bottle do
    cellar :any_skip_relocation
    sha256 "44dfdb9b488a54c9c43c8d22ee3bdb944c4676c6b2daa80c8f3c48499aad0f45" => :sierra
    sha256 "68e42b3562ff1f670262af629520a5c409de973f8c02b43a9aa366bf9d1da469" => :el_capitan
    sha256 "d35bd30b9fc1671a4fb020d39a3c95d9505e3236a6d7b973b0cc4523456c487f" => :yosemite
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
