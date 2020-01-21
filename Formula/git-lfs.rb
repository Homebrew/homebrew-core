class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-v2.10.0.tar.gz"
  sha256 "07fd5c57a1039d5717dc192affbe3268ec2fd03accdca462cb504c0b4194cd23"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2c6e5fac4c30b021c7b193e4e324df245e67caff2f6f8eaf59b7170475e95825" => :catalina
    sha256 "dc6d138b8add71ea2cc9b6dc18401fac9e832afcaf4d267b7494615bc52e59fe" => :mojave
    sha256 "ef1874b898390008d6eb1b257d3d04d54ce5c89b9431e25b036a83588ed01fd5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

      system "make", "vendor"
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
