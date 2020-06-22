class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/6.0.0.tar.gz"
  sha256 "a823c12e4bf74e2f07ee80e597500e5f5120dcd8fa345e67e2c03544fd706ffe"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f69cac7f7e864f32d29cb62ba6b912eb02dd18ba1bde570172f3c7a2a4b50f79" => :catalina
    sha256 "f69cac7f7e864f32d29cb62ba6b912eb02dd18ba1bde570172f3c7a2a4b50f79" => :mojave
    sha256 "f69cac7f7e864f32d29cb62ba6b912eb02dd18ba1bde570172f3c7a2a4b50f79" => :high_sierra
  end

  conflicts_with "git-utils",
    :because => "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zschrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end
