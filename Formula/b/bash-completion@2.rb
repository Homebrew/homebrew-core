class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.17.0/bash-completion-2.17.0.tar.xz"
  sha256 "dd9d825e496435fb3beba3ae7bea9f77e821e894667d07431d1d4c8c570b9e58"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea80dd75c8d7b48e1ed47b5c1b36c5171ec31640ea290ecc3fb8a6f8941d4fbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea80dd75c8d7b48e1ed47b5c1b36c5171ec31640ea290ecc3fb8a6f8941d4fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea80dd75c8d7b48e1ed47b5c1b36c5171ec31640ea290ecc3fb8a6f8941d4fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f958af6492d1c86a775cb5fedbbece68ea1853208a4b92fa169c527ca12d0cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea80dd75c8d7b48e1ed47b5c1b36c5171ec31640ea290ecc3fb8a6f8941d4fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea80dd75c8d7b48e1ed47b5c1b36c5171ec31640ea290ecc3fb8a6f8941d4fbf"
  end

  head do
    url "https://github.com/scop/bash-completion.git", branch: "main"

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
