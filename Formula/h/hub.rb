class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/mislav/hub/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "e19e0fdfd1c69c401e1c24dd2d4ecf3fd9044aa4bd3f8d6fd942ed1b2b2ad21a"
  license "MIT"
  head "https://github.com/mislav/hub.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "262eee2bbe1a89928ff5df203894ea17f4a1a3e4741e9ff2ef0f0bc5d48a0cd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "90a1cf13fdd2a83b764953421cdf3ef3fa115d82d893f0b4fec100539c97773f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7df6f6e443e8e00fa18c8bd5e88fa666fe0a40659832e478a0d2345233ca374d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b4d7c179ca172a5d00781021defae38a452408eab7077e26ad4f317cfad9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00602733d9a4c8049e34cb20a7c96dbd51f98a60e1cb5fbc9aec72663324ce89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19d761270350d4c4b6d5118d096dc7c012e7b58b43c0d81f9c6d8bded1888dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "007fb6c7dcfd7feb24afdcd95d016756357eb5bf38716c887e7839e4eeebfde7"
    sha256 cellar: :any_skip_relocation, ventura:        "737b57476182bf2e937a570be65f991590d79d84b9d14299fe15c2711a715113"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c647211cc8a8e9aa9bedfaa4cb079a3a5fafea3f8378c7eaf5c50e2503cd0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c480f3de5f449a741f88718194c129d597f0fe0db8b2130c1ccf4daa9a8dfca"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf05855839a9d7ec6e7bee6796e3cb5fc473500cffc002366cf98c09a805b69"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d46ee6b0e23f3b74b8f51d6651995bc8ebf8bfaeebcd407a1201723b17c8c681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "213636e856404251ffd7897357ab91cc9519d3852e4b28cbb43575988d9bbc1b"
  end

  depends_on "go" => :build

  uses_from_macos "ruby" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

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
