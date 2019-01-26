class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.8.3.tar.gz"
  sha256 "26bc1bc6fd8b6af379445728450d9c1e26a6d1861fdff5c2b552562eb7487a96"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b0e49df68b45b892549264c605cf16541e2c25a02351980a2893619cc915b23" => :mojave
    sha256 "3c82fa2b5081e5b35870055a6a465be36884ccf4a5b92e23b3a36433346d0182" => :high_sierra
    sha256 "9473b772485a2c4a7e4f23c64eafcd4afab3b53e847c49beff926111a43b2f01" => :sierra
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
