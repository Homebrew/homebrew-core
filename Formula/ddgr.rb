class Ddgr < Formula
  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.5.tar.gz"
  sha256 "b442f707a2c2ead42233d3bf3a9bf919e32ab9860e20d9d39f860840c13c0392"

  bottle do
    cellar :any_skip_relocation
    sha256 "d50cfaa62b8232b656b53d65940094099d3a00f000566f4ce47a80c5c58c64e8" => :mojave
    sha256 "456b18ce643a60a535ddf4de0da78ec67158b0b8d5aea1df8d5e16143f10e5e7" => :high_sierra
    sha256 "456b18ce643a60a535ddf4de0da78ec67158b0b8d5aea1df8d5e16143f10e5e7" => :sierra
  end

  depends_on "python"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/ddgr-completion.bash"
    fish_completion.install "auto-completion/fish/ddgr.fish"
    zsh_completion.install "auto-completion/zsh/_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/ddgr --noprompt Homebrew")
  end
end
