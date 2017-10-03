class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.2.tar.gz"
  sha256 "42027b85b258d6f1f4660a756603c3ea46ac3d0a9064b8a818a69873e7463d85"

  bottle do
    cellar :any_skip_relocation
    sha256 "c09f13eeff6c683d440e09880b36df88aeaf7f22f0d9db0b3db3932fc52d40c1" => :high_sierra
    sha256 "36922feadf83ab4d60a7a51584750359b19753f72d9e5050d6832d13de1d4afc" => :sierra
    sha256 "876efdf515ba20126c9dee33d1dfe2d7335085fb6f462bc8243831259c7d5e15" => :el_capitan
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
