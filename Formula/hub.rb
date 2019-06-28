class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.1.tar.gz"
  sha256 "315114e46bbf583e23341e171c8e1a5efdbe96c04868ff0b343cf367f65f67a0"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ccecb218ad8807cce2109d881f8d047d824c9ad09731523af067cd140dd0920" => :mojave
    sha256 "b1480c8de56ffea13694671327d17b1366b56f025434390909484b05c74836f6" => :high_sierra
    sha256 "6d176af6a6dac59b274fb9c00a5b95fba35a670d3b45eaa922682ff5256f71a3" => :sierra
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
