class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.3.2.tar.gz"
  sha256 "bd59af407e9a45c8a6fcbeb720790cb9eccff21dc7e184716a60e29f14c68d54"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jarun/googler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "843e6394f80e096decffc6fa0f9089ab224889ae6e14ce96c82a56c854905d28"
  end

  deprecate! date: "2022-01-24", because: :repo_archived

  depends_on "python@3.10"

  # Upstream PROTOCOL_TLS patch, review for removal on next release (if any)
  # https://github.com/jarun/googler/pull/426
  patch do
    url "https://github.com/jarun/googler/commit/52e2da672911cd9186bd3497fcdf81149071e72b.patch?full_index=1"
    sha256 "d8d8a813b6c0645990b8b1849718b0fc406f4201068ca483f27498599fd86cbf"
  end

  def install
    rewrite_shebang detected_python_shebang, "googler"
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
