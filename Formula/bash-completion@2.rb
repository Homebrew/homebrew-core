class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.10/bash-completion-2.10.tar.xz"
  sha256 "123c17998e34b937ce57bb1b111cd817bc369309e9a8047c0bcf06ead4a3ec92"

  bottle do
    cellar :any_skip_relocation
    sha256 "457ae745fa3c9ad6cda7f497cd312bcc70f469a723e1a9b0d59af87234a9b3d3" => :catalina
    sha256 "457ae745fa3c9ad6cda7f497cd312bcc70f469a723e1a9b0d59af87234a9b3d3" => :mojave
    sha256 "457ae745fa3c9ad6cda7f497cd312bcc70f469a723e1a9b0d59af87234a9b3d3" => :high_sierra
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
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following to your ~/.bash_profile:
      [[ -r "#{etc}/profile.d/bash_completion.sh" ]] && . "#{etc}/profile.d/bash_completion.sh"

    If you'd like to use existing homebrew v1 completions, add the following before the previous line:
      export BASH_COMPLETION_COMPAT_DIR="#{etc}/bash_completion.d"
  EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end
