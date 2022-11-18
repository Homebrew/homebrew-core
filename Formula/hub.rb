class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.14.2.tar.gz"
  sha256 "e19e0fdfd1c69c401e1c24dd2d4ecf3fd9044aa4bd3f8d6fd942ed1b2b2ad21a"
  license "MIT"
  head "https://github.com/github/hub.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b4d7c179ca172a5d00781021defae38a452408eab7077e26ad4f317cfad9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00602733d9a4c8049e34cb20a7c96dbd51f98a60e1cb5fbc9aec72663324ce89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19d761270350d4c4b6d5118d096dc7c012e7b58b43c0d81f9c6d8bded1888dd9"
    sha256 cellar: :any_skip_relocation, ventura:        "737b57476182bf2e937a570be65f991590d79d84b9d14299fe15c2711a715113"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c647211cc8a8e9aa9bedfaa4cb079a3a5fafea3f8378c7eaf5c50e2503cd0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c480f3de5f449a741f88718194c129d597f0fe0db8b2130c1ccf4daa9a8dfca"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf05855839a9d7ec6e7bee6796e3cb5fc473500cffc002366cf98c09a805b69"
    sha256 cellar: :any_skip_relocation, mojave:         "bcbae9c683d76f3395665467ba0f0c00c60c12c84022f72faba4b8981724b563"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8800cda4532784bf764ea6116a06c81d8d90bb3d36d8ecf295e64f9dd647c4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "213636e856404251ffd7897357ab91cc9519d3852e4b28cbb43575988d9bbc1b"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  uses_from_macos "ruby" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  on_linux do
    depends_on "util-linux"
  end

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
