class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-v3.5.1.tar.gz"
  sha256 "fc19c7316e80a6ef674aa4e1863561c1263cd4ce0588b9989e4be9461664d752"
  license "MIT"

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6079593e9b2008a74a71a109518d49f522939c98770fe233fcc4147d9e10439d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "241e895f27aa45b46f459bf78ac8b031748c329e3d4b5c24b5343d61dbbb1472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac1391a61a43b8b4c28efc591a96683443e1c66f17e4fdd503b27c60be88400"
    sha256 cellar: :any_skip_relocation, sonoma:         "62c2e70ba22ed9c265c8a994c2d54021588d6b581d599be627a802e21f5cb2a7"
    sha256 cellar: :any_skip_relocation, ventura:        "bbe0d1cdec9bc6838bcb3cbc18782e7a131d7e4d2623acd30f6b809e800283c1"
    sha256 cellar: :any_skip_relocation, monterey:       "702a41d4bb7fb85b3232ceb3a6d590b5777e09d147a531f9c65ee4838101f7d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80391a7442b2c4a592f8c66ab24e07537559b3a4f420a85c60661c1182ddf197"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

    bin.install "bin/git-lfs"
    man1.install Dir["man/man1/*.1"]
    man5.install Dir["man/man5/*.5"]
    man7.install Dir["man/man7/*.7"]
    doc.install Dir["man/html/*.html"]
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
