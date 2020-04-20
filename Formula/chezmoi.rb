class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/v1.8.0.tar.gz"
  sha256 "b55289372b0e419d9e759f3193cca366a0ae1de2bd72f523d49a0e8ca8567a47"
  head "https://github.com/twpayne/chezmoi.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"

    system "make", "completions"
    bash_completion.install "completions/chezmoi-completion.bash"
    zsh_completion.install "completions/chezmoi.zsh"

    prefix.install_metafiles
  end

  test do
    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
