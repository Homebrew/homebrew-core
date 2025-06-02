class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.16.0/bash-completion-2.16.0.tar.xz"
  sha256 "3369bd5e418a75fb990863925aed5b420398acebb320ec4c0306b3eae23f107a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7696534939d76665695a0bc12c1bab0a9cd0729264b16585bc5bc44a0bae5cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7696534939d76665695a0bc12c1bab0a9cd0729264b16585bc5bc44a0bae5cfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7696534939d76665695a0bc12c1bab0a9cd0729264b16585bc5bc44a0bae5cfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "eae0306c63a1d8dec18b5762d0d33689ec876f85c7e3fc30602103e2a03de498"
    sha256 cellar: :any_skip_relocation, ventura:       "eae0306c63a1d8dec18b5762d0d33689ec876f85c7e3fc30602103e2a03de498"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7696534939d76665695a0bc12c1bab0a9cd0729264b16585bc5bc44a0bae5cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7696534939d76665695a0bc12c1bab0a9cd0729264b16585bc5bc44a0bae5cfe"
  end

  head do
    url "https://github.com/scop/bash-completion.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  conflicts_with "bash-completion",
    because: "each are different versions of the same formula"

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
