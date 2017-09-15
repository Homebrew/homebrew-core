class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.0.tar.gz"
  sha256 "4f972b4578d09a464cfc730df3a0ff6255d5ca0e09ea2913b3b6515d9c987d81"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1baf04f97a2afd9396d6d70f180b9f89545abc0888988f1c29bf9e78ab25e40" => :sierra
    sha256 "e21ef982423a4e4d6431aa3cd88472a7f63571f68e1d3f7a60100d3ca39c933b" => :el_capitan
    sha256 "2de7ea4da250b0e287893f358a6a3a7250086f9b4a6c742e2362bf9b91699c79" => :yosemite
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
