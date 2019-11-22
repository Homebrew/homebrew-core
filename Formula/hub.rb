class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.13.0.tar.gz"
  sha256 "0b5147a25aa8dff37d6c88b2a30ed38c05d35e03c64d79039925dcb49de80940"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "039088d14cd3eb740f57f4a3f2703f6b71716abf1369a3878a3bd1b93b84522b" => :catalina
    sha256 "b9f7bda85596f33a7417d1fbd4a140b8f583d3cf862f4d3c7a9ac0066ee18071" => :mojave
    sha256 "30091202eec232f4f7b3e2194721f20ece42392c1171f6eb45bfe7b6ee5c1665" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/hub").install buildpath.children
    cd "src/github.com/github/hub" do
      system "make", "install", "prefix=#{prefix}"

      prefix.install_metafiles

      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
      fish_completion.install "etc/hub.fish_completion" => "hub.fish"
    end
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
