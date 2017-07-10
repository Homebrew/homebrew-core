class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.2.1.tar.gz"
  sha256 "fede2b31b0539fd4a580f831867caac1b5d5dc4405e938c4ee0bfeacfb78ad7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d925d597a2b0e67d123b187dc1687fcb21748d30e60ca2c37001ad1863eeedb1" => :sierra
    sha256 "4dc85cb520ec2127262fc2a96ffc093a56092a06035ebb4a7bd40f603393d293" => :el_capitan
    sha256 "a27cc0c1f58d44513106c9e13e7b4303e2270e9ffbc9342bc21e5e147153f003" => :yosemite
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
