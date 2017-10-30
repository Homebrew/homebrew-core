class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.7/bash-completion-2.7.tar.xz"
  sha256 "41ba892d3f427d4a686de32673f35401bc947a7801f684127120cdb13641441e"
  head "https://github.com/scop/bash-completion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbd57a0d85d776ca61c6d9dbf6ae3a81d1c2f89c98852a355b5b0ccb5dec20dc" => :high_sierra
    sha256 "e6f6452c42646f3bc8687ed02811612c8689c34d8b12b6826042ea3b0598f53d" => :sierra
    sha256 "f3b55c185807dc431ec0d01693c99fdad34c25f644bd2e9d54225df2610f7734" => :el_capitan
    sha256 "f3b55c185807dc431ec0d01693c99fdad34c25f644bd2e9d54225df2610f7734" => :yosemite
  end

  depends_on "bash"

  conflicts_with "bash-completion", :because => "Differing version of same formula"

  def install
    inreplace "bash_completion", "readlink -f", "readlink"

    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following to your ~/.bash_profile:
      if [ -f #{HOMEBREW_PREFIX}/share/bash-completion/bash_completion ]; then
        . #{HOMEBREW_PREFIX}/share/bash-completion/bash_completion
      fi
    EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end
