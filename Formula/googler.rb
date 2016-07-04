class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.5.1.tar.gz"
  sha256 "203dabbe6533cd66f8bbc6d4b93f691670086412dbad4879904c9f40ffcfa315"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97396a30d73ac090e22aefde1cea4ab6de8083b4cd6e663c6d2b47a8f5a9bd09" => :el_capitan
    sha256 "b7d227a6ddd5bb90f24b3790dd50e157b82c71f30c5868fb99084f6269d997da" => :yosemite
    sha256 "14adf9b9fcb671cc8ea1a3788e7c97bc1cfc86a4da9c648e28329341eeeae02e" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match /Homebrew/, shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
