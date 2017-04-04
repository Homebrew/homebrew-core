class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.5/bash-completion-2.5.tar.xz"
  sha256 "b0b9540c65532825eca030f1241731383f89b2b65e80f3492c5dd2f0438c95cf"
  head "https://github.com/scop/bash-completion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb3aa25f0e5d40a7e92d2e79e521a01558a95c4c4e31999697ba5fdc7c7c28f8" => :sierra
    sha256 "fb3aa25f0e5d40a7e92d2e79e521a01558a95c4c4e31999697ba5fdc7c7c28f8" => :el_capitan
    sha256 "fb3aa25f0e5d40a7e92d2e79e521a01558a95c4c4e31999697ba5fdc7c7c28f8" => :yosemite
  end

  depends_on "bash"

  conflicts_with "bash-completion", :because => "Differing version of same formula"

  def install
    inreplace "bash_completion", "readlink -f", "readlink"

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
