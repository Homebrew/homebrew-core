class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.10/bash-completion-2.10.tar.xz"
  sha256 "123c17998e34b937ce57bb1b111cd817bc369309e9a8047c0bcf06ead4a3ec92"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b162bc315662861c84f428b262c9883d34ff7eab80ddff09148f81aef4d5d7ff" => :catalina
    sha256 "b162bc315662861c84f428b262c9883d34ff7eab80ddff09148f81aef4d5d7ff" => :mojave
    sha256 "b162bc315662861c84f428b262c9883d34ff7eab80ddff09148f81aef4d5d7ff" => :high_sierra
  end

  head do
    url "https://github.com/scop/bash-completion.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  conflicts_with "bash-completion", :because => "Differing version of same formula"

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "readlink -f", "readlink"
      # Automatically read Homebrew's existing v1 completions
      s.gsub! ":-/etc/bash_completion.d", ":-#{etc}/bash_completion.d"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile:
        [[ -r "#{etc}/profile.d/bash_completion.sh" ]] && . "#{etc}/profile.d/bash_completion.sh"
    EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end
