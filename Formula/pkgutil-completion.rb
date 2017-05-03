class PkgutilCompletion < Formula
  desc "Bash completion for macOS's pkgutil"
  homepage "https://github.com/ronmrdechai/pkgutil-completion"
  url "https://github.com/ronmrdechai/pkgutil-completion/archive/1.0.tar.gz"
  sha256 "123e6c883d71f53a2af3e26a7e6a5909dd365abde8215b14d7aca7c59221df42"

  bottle :unneeded

  def install
    bash_completion.install "pkgutil.bash" => "pkgutil"
  end

  test do
    assert_match "-F _pkgutil",
                 shell_output("bash -c 'source #{bash_completion}/pkgutil && complete -p pkgutil'")
  end
end
