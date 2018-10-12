class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.7.1.tar.gz"
  sha256 "1ceadab40fea49a113f46807a5c7297fcf145eeaa8128e33d53aadb275377f37"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "971af061566b3156a2f69fff34217f2373cee171c90b98ab8b39e78fa3d16f38" => :mojave
    sha256 "543a26a00407a7677a9f568c37887acf16d2efab36f86df00f17b2c87ed0e7ea" => :high_sierra
    sha256 "543a26a00407a7677a9f568c37887acf16d2efab36f86df00f17b2c87ed0e7ea" => :sierra
    sha256 "543a26a00407a7677a9f568c37887acf16d2efab36f86df00f17b2c87ed0e7ea" => :el_capitan
  end

  depends_on "python"

  def install
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
