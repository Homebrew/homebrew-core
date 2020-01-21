class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.14.1.tar.gz"
  sha256 "62c977a3691c3841c8cde4906673a314e76686b04d64cab92f3e01c3d778eb6f"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ecb167b7862314de59c67deb9c8dcbcec17ff78cc949cd7ce8309efb9f269e1e" => :catalina
    sha256 "22e8f62a10d5b985760ca626506b32a31c5a8f298df40a0560e034c7193c5bca" => :mojave
    sha256 "b44b83e821252707efd46b4d1b2920b34a540977941061280a148cf90f4b8e1d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "prefix=#{prefix}"

    prefix.install_metafiles

    bash_completion.install "etc/hub.bash_completion.sh"
    zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    fish_completion.install "etc/hub.fish_completion" => "hub.fish"
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
