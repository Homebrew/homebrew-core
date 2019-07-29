class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.3.tar.gz"
  sha256 "197242fea670353688c541d2e4584b449f18c354a01d89bf1667ea33c0071ddc"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6db1533af8204ae6dde7a76824f3b0a82d9fed311ea5e4b2e9835194f1690474" => :mojave
    sha256 "032055d93738c1472e8337edf763964922f94b2b2b548963ef28f0651d1ca5a4" => :high_sierra
    sha256 "969a01ec7359163057ea27f9a8c4d21d197bc67b95680ae15810f87e0cf0c1f0" => :sierra
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
