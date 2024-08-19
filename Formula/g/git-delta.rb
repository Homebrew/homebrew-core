class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.18.0.tar.gz"
  sha256 "1cdd61373b34cd6d20a0184efc9e445939f743d92b2b89a83ec787b4cf93f5a4"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c11e3d862819f2080451e72f0bc37d4b62e843a31622cb0807c8f939a50d78e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e205757d1c3c4778b1f575c496807a3d10d002c16c4604fa57d4ddf729de4e3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2345730a1d8cc8cc687437fdf9b43191088661a83249ca33c70b533a94546821"
    sha256 cellar: :any_skip_relocation, sonoma:         "705fe66c3f1d803536f608e31045777b7f447b5f47710428675264fdb18437bc"
    sha256 cellar: :any_skip_relocation, ventura:        "b42dca2290df94a78e01b3cdfb0d729bc3d6d520ba49e0a926ca3f9367a6e9a5"
    sha256 cellar: :any_skip_relocation, monterey:       "9e607fd46ff49a326f82ea6828c04c7d7f718086efc464dbeeece9948749ea2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce98431a38ecb87a5797ad87dcd2c1bb3ee841a71a02cea256b015ad9744b9dc"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
