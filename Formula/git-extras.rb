class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/6.1.0.tar.gz"
  sha256 "7be0b15ee803d76d2c2e8036f5d9db6677f2232bb8d2c4976691ff7ae026a22f"
  license "MIT"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ed4aa34fdbb50977413ff1860227d7c66cc339f614ee65fe4b9bbdc82bc224e" => :big_sur
    sha256 "a26aa6b1ef178b8c5c8a7fb61ec04e5e0b43fdfe9c253703273c2c3536935826" => :arm64_big_sur
    sha256 "abb85334f41bfa73f650bc138caecf8a35cc0af8951628c97b09d68c30fbbe60" => :catalina
    sha256 "afe41a9918fd0951a2e2b4badfbb6bca57ca2161d6ef82f452604e1f73154825" => :mojave
    sha256 "ffc36aced07c7ca6a5e8ccb8b4dbfcdd50742efd780d9a1b668189813a3486cf" => :high_sierra
  end

  conflicts_with "git-utils",
    because: "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zshrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end
