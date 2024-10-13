class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.14.0/bash-completion-2.14.0.tar.xz"
  sha256 "5c7494f968280832d6adb5aa19f745a56f1a79df311e59338c5efa6f7285e168"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "35c3dfec6b25b505f6d44bc650a7be26a3a66619759d8c0df22591cf8a3163f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddd730a4ec0c0fe21ffa9c0d48009b8d32c32ca3f4babb61a5b9aa8513432019"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59600ca38f753a80adf4cd18262e7c1715e48594d7ed0a5158478b7bb5150e41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6e0b32b4f7ba34a1e601b200d8d6fd82178ba10d10c9933acec4156342f97a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9ce334d3e044c6a45ea6560397624a2ba3fcf46d2424663b41f63c67540423c"
    sha256 cellar: :any_skip_relocation, ventura:        "4613fd0d18d2dd5609238cae627980a5bff8b8d5a24c055b13b5163c04b760ee"
    sha256 cellar: :any_skip_relocation, monterey:       "a5613d8b636cf1cf4a40e8ea02d035310ea184648e2f616b6f1f9cbea8d701a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd97d8e15058a780ce9b0e2b411b50911009e00a97d1504ac653ea1557d70aa6"
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
