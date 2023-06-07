class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.0.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.0.tgz"
  sha256 "7947eae8e93e001dc1dcd3d91df2c0f488e043575143cde5c2be1c245c327a67"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4377099086a262797286aa5cf47d8218df9fdac84902a36f167ac48b5f7df209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb88fe3102bdaf90f9f787dc594d7c235f4839d7395091fdcd891e07e63034d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f25c133ec9bc2ceb9f1989a2270ce1ceabfbe963711de964050c11bdc46cc8"
    sha256 cellar: :any_skip_relocation, ventura:        "14ed9c779b78f0e80ea3db67e97e33a9f62846f209f017e8cc400b30bdb6e791"
    sha256 cellar: :any_skip_relocation, monterey:       "10e0918a0510edd5995713ec0eef0a95a409ab3e0895aa0ed59c8ecf49a7a42a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f5de40c6a349a01f9e8167bbc49947255bbf2db6b720b292fda6ffa7624dafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9822101fe82f6f409d96549f20e1e74b68e307bd3c4e72fcbb31cef4316cf46"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
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
