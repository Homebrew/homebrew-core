class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.2.tar.gz"
  sha256 "42027b85b258d6f1f4660a756603c3ea46ac3d0a9064b8a818a69873e7463d85"

  bottle do
    cellar :any_skip_relocation
    sha256 "5db5b99c201c4f8bb62b88593b1471a548acf8962bf59e89c60a94b72c79a565" => :high_sierra
    sha256 "8f8f4b76b4a5746fcada063c25a328cd1536dadda6ed19acc9244e7de0d07b75" => :sierra
    sha256 "8c20820372685488438c5cb854c4e2148bafa0096ee7bf32ccf4d3f12e3b7e33" => :el_capitan
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
