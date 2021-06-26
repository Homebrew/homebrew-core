class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.13.3/git-lfs-v2.13.3.tar.gz"
  sha256 "f8bd7a06e61e47417eb54c3a0db809ea864a9322629b5544b78661edab17b950"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af433100a9ba1c1b222d01bee070704eb74cdd75038b7c333a9ff6e8e335375c"
    sha256 cellar: :any_skip_relocation, big_sur:       "153252f96cb3d77c2980f18c5eab591f237b011f4426f1faf918ecdc51969a33"
    sha256 cellar: :any_skip_relocation, catalina:      "c99996a1fbfee4c5d4d0ac3cd38d42d884224ab3f305566ed13309b6bc63b9b4"
    sha256 cellar: :any_skip_relocation, mojave:        "69d6da76ac82d66f0cf36352f7c65af24918241241fbda5fe4ab74030094e597"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

      bin.install "bin/git-lfs"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      doc.install Dir["man/*.html"]
    end
  end

  def caveats
    <<~EOS
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
