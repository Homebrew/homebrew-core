class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.5.2.tar.gz"
  sha256 "0ab21f0f9b6c40acd9748a1669f1023ef38f913d8be83bbf7b7c7d983bd3c4d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "3377acf8787d371ad90ef8b7ff71d6b57b449f9ff5b39c3a90238b67347e4801" => :mojave
    sha256 "1d63156198f40531d37835cef7aea1c0d3bccd139e5c479275ee9cc23f8f5e57" => :high_sierra
    sha256 "954c4e5cc6f3351752b679a75ada30f3b58605c2bbfdc9f41c7d034176ba822b" => :sierra
    sha256 "6254b44ef41509d07398976dbefa8cab59cbd9eb25d59fa40f8ed5d30e2aecf4" => :el_capitan
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GOPATH"] = buildpath
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

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
