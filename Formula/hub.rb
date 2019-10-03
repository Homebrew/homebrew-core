class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.8.tar.gz"
  sha256 "72d09397967c85b118fc1be25dc0fc54353f4dea09f804687a287949c7de7ebe"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b24e7d3a96bacde444ab29858642444bca94d91f3fbf84a7fe29052f64c1535" => :catalina
    sha256 "9ac84d4f756253267655ca78c1d4eed783f63d3810e1d796e913a7c1a11cafcd" => :mojave
    sha256 "f54bc785009169252b110dc9f5a900a5b0ae16900c5f9f387df02c303f1343ed" => :high_sierra
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
