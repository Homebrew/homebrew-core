# NOTE: version 2.0 is out, but it requires Bash 4, and macOS ships
# with 3.2.48. See homebrew-versions for a 2.0 formula.
class BashCompletion < Formula
  desc "Programmable completion for Bash 3.2"
  homepage "https://bash-completion.alioth.debian.org/"
  url "https://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fe6e1bfcd0c9c93c8d2845738ebf3419a48374c30dc5259eb0967a9212c5b669" => :sierra
    sha256 "aaa0801956062f69a0e1c2c5214c110ef86828474508a3b4925f5e1cf11b0ce5" => :el_capitan
    sha256 "aca381fd5650b1d0ef886d824f1846e4934b6dc7eaf062a6be4bc17251245af3" => :yosemite
    sha256 "f745eeca7d3c9f98280a565064a54a1a177ad0792d5ccaeecf5d3c7e1d18d783" => :mavericks
  end

  # Backports the following upstream patch from 2.x:
  # https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=commitdiff_plain;h=50ae57927365a16c830899cc1714be73237bdcb2
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740971
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c1d87451da3b5b147bed95b2dc783a1b02520ac5/bash-completion/bug-740971.patch"
    sha256 "bd242a35b8664c340add068bcfac74eada41ed26d52dc0f1b39eebe591c2ea97"
  end

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "/etc/bash_completion", etc/"bash_completion"
      s.gsub! "readlink -f", "readlink"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following lines to your ~/.bash_profile:
      if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
      fi
    EOS
  end

  test do
    system "bash", "-c", ". #{etc}/profile.d/bash_completion.sh"
  end
end
