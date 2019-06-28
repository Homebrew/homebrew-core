class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.1.tar.gz"
  sha256 "315114e46bbf583e23341e171c8e1a5efdbe96c04868ff0b343cf367f65f67a0"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "382da345a9c86a1ad4a02e223759b556b7f6b7fbb21343d7502809f59aced7c4" => :mojave
    sha256 "4f0044e585f97ea334a329bbc40b4976fc71de7c6d78bc5962fbaffbe8b3e81f" => :high_sierra
    sha256 "c2f47c4decfee2a4c410cab3f8f2d1234aa2f1e69acb0307e625a9a4edf7b773" => :sierra
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
