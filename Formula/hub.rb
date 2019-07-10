class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.2.tar.gz"
  sha256 "3db0719e41731c57b8765b7f486aa91cee57bb7d39d5553d480d87a4ac6c2ee6"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfc618a1e69d697c8223a7b130abbda9a60314b77cf7c979422145d92b6184bf" => :mojave
    sha256 "123356c784cf070ba54632d6e1acc5295ba4bedcaceb757c68775571d518a0fc" => :high_sierra
    sha256 "e92f17dd4122ba257b91570ab5417685bea9d82e640008da6980af0d9cad1530" => :sierra
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
