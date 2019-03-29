class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.11.1.tar.gz"
  sha256 "dfd6531cdd31f004dcbcd2764dea4e1c040e72358ae79758a6c3060b9e743371"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "795f81c453ebfd36f45df5cd1861a1e6b2149b34749681a1d921689a784b82c8" => :mojave
    sha256 "1ae26a75c1ecabb2b8433983928c582c6fc62a34dbc28c548c65f0423c5c4117" => :high_sierra
    sha256 "9acc89b1e98d60874939c2f53d4c5781f1c6237ef16908b2e172c3d71dda73ef" => :sierra
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
