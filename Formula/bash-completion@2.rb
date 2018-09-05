class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.8/bash-completion-2.8.tar.xz"
  sha256 "c01f5570f5698a0dda8dc9cfb2a83744daa1ec54758373a6e349bd903375f54d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed117a12f9b0fff798402a52c6823e3f7b167bcaadbbe1e42798870aa04ac80e" => :mojave
    sha256 "08ccf4c84786d7881c5d58fd9122b62e828859c57b28652df923a105f9a94b8b" => :high_sierra
    sha256 "08ccf4c84786d7881c5d58fd9122b62e828859c57b28652df923a105f9a94b8b" => :sierra
    sha256 "08ccf4c84786d7881c5d58fd9122b62e828859c57b28652df923a105f9a94b8b" => :el_capitan
  end

  head do
    url "https://github.com/scop/bash-completion.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  conflicts_with "bash-completion", :because => "Differing version of same formula"

  def install
    inreplace "bash_completion", "readlink -f", "readlink"

    system "autoreconf", "-i" if build.head?
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
