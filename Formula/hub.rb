class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.10.1.tar.gz"
  sha256 "d0c0c0632180f6bbb1e451f1369e88157ae19f40229dfd8bee5bde6b75f4536f"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b23b59540c95ee7b987ff1c8bb494b57b971481a5dc92709833d17a6eb766af3" => :mojave
    sha256 "b688a3df107cc125a8b964466793972c7392cf0af7b530ff26124f8270b959c2" => :high_sierra
    sha256 "90f5efb667658b5982b9ae2e71af04836bcb5046c20cba5c5dd30219c2416394" => :sierra
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
