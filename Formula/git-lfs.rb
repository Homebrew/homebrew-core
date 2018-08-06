class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.5.1.tar.gz"
  sha256 "85c3148c7cbd9216e356b9317bc726ff8d982b37654ec1b26c537238ba9bfd8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "95d64470a27890b423173f2d576284c4d49fc6be904ecd0440b1963071dec388" => :high_sierra
    sha256 "c8b8fd4cf6fd76c5979a96c1a3a4657d96af4bc9bb0f86e890fd36956ec45424" => :sierra
    sha256 "75bd4b8b9443eda7e75ccfdb04d72815ce01ac41dc73e0aad2a61a0a72faa089" => :el_capitan
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
