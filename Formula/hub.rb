class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.11.0.tar.gz"
  sha256 "65ebc6e9521147dff04513e9b4a1e733241cd0ab93a61446795ad9fe537b87f2"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7af1dd6c579caaa5b23917bf4e26a521c020e1ef3a4db9319a1c6dc0d5968c2c" => :mojave
    sha256 "dd45e816922b3725349f8d62c582899ff28b0f4ff74b8d5f2c14ba075e0ac0fd" => :high_sierra
    sha256 "c33619d87240acd6ede9e0e2e9f29e7cd3b0a6822d043a68b2c352086d1c9cb4" => :sierra
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
