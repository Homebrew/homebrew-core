class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.11.2.tar.gz"
  sha256 "1a80685d3d4fe14012c4f5e5cda9a2c5fe680a81729e692008aa1414f8e1f972"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a628edefdd1a57f8f6a507ba44e78ed51032fa7c077d41bc269a23205e4bcd9" => :mojave
    sha256 "77ce20f18bbcd877b90be0abed790b4c3c5b8f87788e5676c271cfa2f31eb570" => :high_sierra
    sha256 "c7646f8ebab05d6b1e47e52831089dbdb79f9c5a83f0f62468f8955293fd2750" => :sierra
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
