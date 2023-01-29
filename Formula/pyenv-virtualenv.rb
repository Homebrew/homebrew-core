class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/v1.2.1.tar.gz"
  sha256 "c60fe08d8d0d5c3ae0eba224081214ce831135d62d75e1d607206411621427d7"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03551b4cbf9bcbf04eb07de5a382fcda83b8591bba38097bfc62f4cc300b1ec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03551b4cbf9bcbf04eb07de5a382fcda83b8591bba38097bfc62f4cc300b1ec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03551b4cbf9bcbf04eb07de5a382fcda83b8591bba38097bfc62f4cc300b1ec6"
    sha256 cellar: :any_skip_relocation, ventura:        "29fdaa2e9516b77cf0cf41f10058115db14e3c31924cd96f9fe226fa56abbd61"
    sha256 cellar: :any_skip_relocation, monterey:       "29fdaa2e9516b77cf0cf41f10058115db14e3c31924cd96f9fe226fa56abbd61"
    sha256 cellar: :any_skip_relocation, big_sur:        "29fdaa2e9516b77cf0cf41f10058115db14e3c31924cd96f9fe226fa56abbd61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b87d0c08b3ad5cb73e33ca631cf14f487b25646c933faf06e91f1d5e311ccbd"
  end

  depends_on "pyenv"

  on_macos do
    # `readlink` on macOS Big Sur and earlier doesn't support the `-f` option
    depends_on "coreutils"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats
    <<~EOS
      To enable auto-activation add to your profile:
        if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
