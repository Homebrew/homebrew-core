class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.4.1.tar.gz"
  sha256 "3f57aa7bc82b21f5ac9c8df33fed853bb8fbefce0a5eecff80a504e56426a48e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bc77f331516796821fb84ee5d35857d3a4e7c9db83bf31a89270e78853c77d6" => :high_sierra
    sha256 "dd19b1d557fd6ae1685a3cb7dab7ef5b9e4494e639857492bfe001d85037fa2d" => :sierra
    sha256 "ef1c05b7fa812d448f7ea1521655fb6a4dab52402ca875520b59450b9bb5c8de" => :el_capitan
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
