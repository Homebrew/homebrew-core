class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.0.tar.gz"
  sha256 "4f972b4578d09a464cfc730df3a0ff6255d5ca0e09ea2913b3b6515d9c987d81"

  bottle do
    cellar :any_skip_relocation
    sha256 "df7ce7e082227113ac8079acf3963410a009823f2f439bc47d94f16725adc0fe" => :high_sierra
    sha256 "9178668ead84676fe95d349559cbc73fdc3f056cf85587bfd266059060b94545" => :sierra
    sha256 "3d2b0d4b58a5505ec3a6258b3c453b04118df4dbec1c656ba73cbccff366d6f7" => :el_capitan
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
