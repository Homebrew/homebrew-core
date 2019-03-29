class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.11.0.tar.gz"
  sha256 "65ebc6e9521147dff04513e9b4a1e733241cd0ab93a61446795ad9fe537b87f2"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4e0da01e15cd962fed5741b8e40cacf203028da00b9a9267db1bd5979fa67a6" => :mojave
    sha256 "a0c54df88036babf5e6d873c9bcc01c5ddad4254760d6848f9f06bd7fbf9d42c" => :high_sierra
    sha256 "33a94fa152a716d8a74e6a2c588c0c3401fab39cae8a94e2f07dbc4dcfcfbbda" => :sierra
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
