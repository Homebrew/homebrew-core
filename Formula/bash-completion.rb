# NOTE: version 2 is out, but it requires Bash 4, and macOS ships
# with 3.2.57. If you've upgraded bash, use bash-completion@2 instead.
class BashCompletion < Formula
  desc "Programmable completion for Bash 3.2"
  homepage "https://bash-completion.alioth.debian.org/"
  url "https://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "fff005f76bbc76442d6106429651df40180543840a1e145eddc58fdd57db1b80" => :sierra
    sha256 "fff005f76bbc76442d6106429651df40180543840a1e145eddc58fdd57db1b80" => :el_capitan
    sha256 "fff005f76bbc76442d6106429651df40180543840a1e145eddc58fdd57db1b80" => :yosemite
  end

  conflicts_with "bash-completion@2", :because => "Differing version of same formula"

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
      [ -f #{etc}/bash_completion ] && . #{etc}/bash_completion
    EOS
  end

  test do
    system "bash", "-c", ". #{etc}/profile.d/bash_completion.sh"
  end
end
