class Powerlevel10k < Formula
  desc "Theme for zsh"
  homepage "https://github.com/romkatv/powerlevel10k"
  url "https://github.com/romkatv/powerlevel10k/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "352e277a60dbdda0a2005758b0c20b35e04a315b98f06bb8a75ef649e9b8c881"
  license "MIT"
  head "https://github.com/romkatv/powerlevel10k.git", branch: "master"

  bottle do
    manifest_sha256 "09abee18a7039e05ca88f82ebc265075075cf93ad218dc2a8c19405930a87663"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdfa907888474e9ecdeb2ac2d07ff0f5f078da4e2eedc9740578f67bb96b27e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdfa907888474e9ecdeb2ac2d07ff0f5f078da4e2eedc9740578f67bb96b27e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdfa907888474e9ecdeb2ac2d07ff0f5f078da4e2eedc9740578f67bb96b27e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c932c025b22888e5892aeb53391e2d64a6628d770aabf706d2bd77c310cf0420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1232f98c8e6314264b00042e24969ea584c508ed563da5c94a5eefd5b29965bb"
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
    output = shell_output("zsh -fc '. #{pkgshare}/powerlevel10k.zsh-theme && (( ${+P9K_SSH} )) && echo SUCCESS'")
    assert_match "SUCCESS", output
  end
end
