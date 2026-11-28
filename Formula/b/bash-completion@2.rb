class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.18.0/bash-completion-2.18.0.tar.xz"
  sha256 "88bcf85124f77f74f2f2f8bcd16ac4382d807a827ede742a64940c7116aea33f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    manifest_sha256 "198ef45d34708fb34b2a1a6e4adfb7a0e08397933cf9dc26c2e5b76ca6e2b189"
    sha256 cellar: :any_skip_relocation, all: "5a5826537a22fd92a5214effe1d41f98343e3d87ac2fc0b9d5ff029462501643"
  end

  head do
    url "https://github.com/scop/bash-completion.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  on_macos do
    depends_on "bash"
  end

  # Allow all bottle to work on macOS without `readlink -f` (12.3+) or `realpath` (13+)
  on_big_sur :or_older do
    depends_on "coreutils"
  end

  conflicts_with "bash-completion", because: "each are different versions of the same formula"

  deny_network_access!

  def install
    # Automatically read Homebrew's existing v1 completions
    inreplace "bash_completion", "(/etc/bash_completion.d)", "(#{etc}/bash_completion.d)"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
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
