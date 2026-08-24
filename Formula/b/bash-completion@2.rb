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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4155c66f3e11be146daec64a9c0121f87dadd27fda2f631b1aa55784016a0c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4155c66f3e11be146daec64a9c0121f87dadd27fda2f631b1aa55784016a0c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4155c66f3e11be146daec64a9c0121f87dadd27fda2f631b1aa55784016a0c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f96ab73a09477ff6eec8b56c8f02e4c2bf9db31bd35274b21616754ed6d0dad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4155c66f3e11be146daec64a9c0121f87dadd27fda2f631b1aa55784016a0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4155c66f3e11be146daec64a9c0121f87dadd27fda2f631b1aa55784016a0c6"
  end

  head do
    url "https://github.com/scop/bash-completion.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  on_macos do
    depends_on "bash"
  end

  conflicts_with "bash-completion", because: "each are different versions of the same formula"

  def install
    inreplace "bash_completion" do |s|
      # `/usr/bin/readlink -f` exists since macOS 12.3. Older systems
      # (including earlier Monterey releases) do not support this option.
      s.gsub! "readlink -f", "readlink" if OS.mac? && MacOS.version <= :monterey
      # Automatically read Homebrew's existing v1 completions
      s.gsub! "(/etc/bash_completion.d)", "(#{etc}/bash_completion.d)"
    end

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
