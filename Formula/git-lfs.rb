class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.4.0.tar.gz"
  sha256 "3f26cd020a965f61c8e8f124a02794d86f46f2fc4627288afe70ed43f398b121"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c402c41266dd1290c8b87ff011913dc20cc0e2eb772159d14424e25518107f2" => :high_sierra
    sha256 "71fd9a8da403714ddc7fba6de9c3fe869532a9c87170c068188e6cfc9f4ef630" => :sierra
    sha256 "2c73e3eb12e01f8d194fd174a31e1be4cafe867d8590d48680da9372fab51d51" => :el_capitan
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
