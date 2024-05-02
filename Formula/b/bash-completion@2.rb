class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.13.0/bash-completion-2.13.0.tar.xz"
  sha256 "c5f99a39e40f0d154c03ff15438e87ece1f5ac666336a4459899e2ff4bedf3d1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb3f1f447d93f7f6b18e196cd735e94a2e8157f33de2e60f4d3d687de79a2e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb3f1f447d93f7f6b18e196cd735e94a2e8157f33de2e60f4d3d687de79a2e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3f1f447d93f7f6b18e196cd735e94a2e8157f33de2e60f4d3d687de79a2e2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e29be6b53324aa6c5fa8d0e58a3f89c3e33577b0c387fe512c9417657619f0b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e29be6b53324aa6c5fa8d0e58a3f89c3e33577b0c387fe512c9417657619f0b"
    sha256 cellar: :any_skip_relocation, monterey:       "5e29be6b53324aa6c5fa8d0e58a3f89c3e33577b0c387fe512c9417657619f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f573a3d9d0870b241f9c6f80d7e608da947a2e06d0137c99ad90f6b48761181b"
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
