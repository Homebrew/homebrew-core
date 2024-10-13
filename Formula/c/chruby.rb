class Chruby < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/postmodern/chruby"
  url "https://github.com/postmodern/chruby/releases/download/v0.3.9/chruby-0.3.9.tar.gz"
  sha256 "7220a96e355b8a613929881c091ca85ec809153988d7d691299e0a16806b42fd"
  license "MIT"
  head "https://github.com/postmodern/chruby.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8caeb54fdc29211e038cb6723c1109ae708ec30b6aeadbd5390af4e8de50cfc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64a6475437b898659d47bded2e62cd7df312d5eb92b87008877755c11a041e34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64a6475437b898659d47bded2e62cd7df312d5eb92b87008877755c11a041e34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a6475437b898659d47bded2e62cd7df312d5eb92b87008877755c11a041e34"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ff541a8d6e1c0f152ec30116c895526e1a7a47ed06a1b853adfb26f8aa35792"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff541a8d6e1c0f152ec30116c895526e1a7a47ed06a1b853adfb26f8aa35792"
    sha256 cellar: :any_skip_relocation, monterey:       "64a6475437b898659d47bded2e62cd7df312d5eb92b87008877755c11a041e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a6475437b898659d47bded2e62cd7df312d5eb92b87008877755c11a041e34"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      Add the following to the ~/.bash_profile or ~/.zshrc file:
        source #{opt_pkgshare}/chruby.sh

      To enable auto-switching of Rubies specified by .ruby-version files,
      add the following to ~/.bash_profile or ~/.zshrc:
        source #{opt_pkgshare}/auto.sh
    EOS
  end

  test do
    assert_equal "chruby version #{version}", shell_output("#{bin}/chruby-exec --version").strip
  end
end
