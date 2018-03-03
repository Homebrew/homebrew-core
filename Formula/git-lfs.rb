class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.4.0.tar.gz"
  sha256 "3f26cd020a965f61c8e8f124a02794d86f46f2fc4627288afe70ed43f398b121"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7c2b6887938ad68e914106ba3e7d61c1828b2a5478b60c57fd6940cb9e67c6d" => :high_sierra
    sha256 "a8bed726486ae5a74ea788cfe649f43b1462664d45b8c00c308f9d1bed9f9e99" => :sierra
    sha256 "0af771189963edc8c59f05a77de9be3a7a3b4f901b1f0cde60c7307e78afcbcc" => :el_capitan
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
