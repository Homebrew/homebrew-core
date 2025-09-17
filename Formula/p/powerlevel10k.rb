class Powerlevel10k < Formula
  desc "Theme for zsh"
  homepage "https://github.com/romkatv/powerlevel10k"
  url "https://github.com/romkatv/powerlevel10k/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "d8187d44b697b3a37a8c4896678b4380e717cbf2850179529358348780a2d3d7"
  license "MIT"
  head "https://github.com/romkatv/powerlevel10k.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "041441647fed3026648bee86884891b68238016a5c84f416c80a2332582460f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8b5a4692b2768f76c867ae5815e2e8b3d05f08053302c69d0b5f7137cefd1fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53d306e0deb9f0ec13c023b1d1b4def2fb96e7280f33a967fa5b0ce1637c47fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53d306e0deb9f0ec13c023b1d1b4def2fb96e7280f33a967fa5b0ce1637c47fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7c1892abfa0b69d3f198c51bcec09e83591dbbbc22ce51f337b065c6bc2e370"
    sha256 cellar: :any_skip_relocation, sonoma:         "df58ced2ccb576d8da9b0f3e5d6986c22414365354872cd2c9e620f2a8ce65e4"
    sha256 cellar: :any_skip_relocation, ventura:        "df58ced2ccb576d8da9b0f3e5d6986c22414365354872cd2c9e620f2a8ce65e4"
    sha256 cellar: :any_skip_relocation, monterey:       "bef10fff91d174c71544f0a1b0d0a1790131fe959cdd1bd4e9d1bcea682f1767"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e94d2b66f4c17f3060ab6440a604401aff259c965b8100e0442419a6448041e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20bde83ee0e3a59d86aaca90273b6a88819264d47892cb23c66b47ab5230c22a"
  end

  uses_from_macos "zsh" => :test

  def install
    system "make", "pkg"
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate this theme, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    output = shell_output("zsh -fic '. #{pkgshare}/powerlevel10k.zsh-theme && (( ${+P9K_SSH} )) && echo SUCCESS'")
    assert_match "SUCCESS", output
  end
end
