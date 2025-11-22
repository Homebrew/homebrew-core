class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.6.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.6.tgz"
  sha256 "5bde628ef05aac598c9f5158c723e7ff5d6feaa869b0dc8effdbdac6d16fcb01"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad3a1ef170e0d7a79348ed08dcf963eca6cad0da36ab8955b318f90ecfc4f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f26aeb3b3aa2c8f1841caed594c5e62d37dd45c194bbc89872d6771810a1351e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc6508c0401f469e8f87adc02d61ba11bcb2e6adc80744e7da2881a380aa57a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2a7668acd64464c280703e528a6c61b54abf88dab6e765d7c7118bea0139e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb172d508f5e64a50b32c2c36c6f535fe377cfd16bbb811325ab0fec9b29af6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc105d19595839778aedf809628cd32e727e65da53d34005cbcdc135e8cea2b"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libsndfile"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
