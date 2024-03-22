class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.12.0/bash-completion-2.12.0.tar.xz"
  sha256 "3eb05b1783c339ef59ed576afb0f678fa4ef49a6de8a696397df3148f8345af9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a89a69189337d02ae9915a7d63f3300a97bfc577a80fb95151b5172d6d8be329"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a89a69189337d02ae9915a7d63f3300a97bfc577a80fb95151b5172d6d8be329"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a89a69189337d02ae9915a7d63f3300a97bfc577a80fb95151b5172d6d8be329"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8a4c8bd99146abfcd893b273e6a4a53d6a47c3768c169f68296bc3e35d0dc2a"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a4c8bd99146abfcd893b273e6a4a53d6a47c3768c169f68296bc3e35d0dc2a"
    sha256 cellar: :any_skip_relocation, monterey:       "c8a4c8bd99146abfcd893b273e6a4a53d6a47c3768c169f68296bc3e35d0dc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b277dc873ae381d168808461328bf1a0580f9e94288990f14de82756cb4441"
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
      s.gsub! "readlink -f", "readlink" if OS.mac?
      s.gsub! "(/etc/bash_completion.d)", "(#{etc}/bash_completion.d)"
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
