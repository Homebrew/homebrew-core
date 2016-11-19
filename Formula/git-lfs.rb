class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v1.5.1.tar.gz"
  sha256 "78ccf3c1161a09315ce0d5cb95d11e4460c88c30e2f3487f773d7acc43a13682"

  bottle do
    cellar :any_skip_relocation
    sha256 "609348c50f20765a97dddb2ffe358727ebbe2fbfb70659e7ec561da7e3ee8393" => :sierra
    sha256 "eb92822755cca9640b103802afea5cae4e86f5a4d2c135410b4878101c78813e" => :el_capitan
    sha256 "c7cbdbb6ecfd7f2ab8885abc894039b31b3f5d03c7b0bdde453df4624fbac8da" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
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
