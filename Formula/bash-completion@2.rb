class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.6/bash-completion-2.6.tar.xz"
  sha256 "61fb652da0b1674443c34827263fe2335f9ddb12670bff208fc383a8955ca5ef"
  revision 1
  head "https://github.com/scop/bash-completion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2ba1f8b4443fc837ac00e798bb8683dd3d41c6e42de880540fe7a3dc0ffd560" => :sierra
    sha256 "387408084796e8f52e5b3197126008a0ba773c07cef22e53438e494282ecd53d" => :el_capitan
    sha256 "387408084796e8f52e5b3197126008a0ba773c07cef22e53438e494282ecd53d" => :yosemite
  end

  depends_on "bash"
  depends_on "coreutils"

  # Temporarily needed as the patch modifies automake files
  # Remove when patch is removed
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  conflicts_with "bash-completion", :because => "Differing version of same formula"

  # Patch to fix legacy autocompletions path
  # Upstream issue: https://github.com/scop/bash-completion/issues/127
  # Upstream PR: https://github.com/scop/bash-completion/pull/132
  patch do
    url "https://github.com/scop/bash-completion/commit/01052d3744afe41d4448d1b19dee94ea3a88dd2f.patch?full_index=1"
    sha256 "e65a6a54d788e94daac35fb1b626b1ab3f20323443602c29baf645b769f3cb64"
  end

  def install
    # Temporarily needed as the patch modifies automake files
    # Remove when patch is removed
    system "aclocal"

    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats; <<-EOS.undent
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
