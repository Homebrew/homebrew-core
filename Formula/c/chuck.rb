class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.3.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.3.tgz"
  sha256 "313b82addbd21838831ed61f02e1a664076fdb97196a72e4d8af6e09803b0432"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da73a1bc4dc342141062e27ce0b6d5184bc386830456fafdbc78e5e1b106b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27226895635e59d8f7b1ee97b914b60937f9397de8f19427f91e60e6ef7c9b45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "270b991d4c9521628b2d2e6b3170701355e9636d03c757a4337923897805b73b"
    sha256 cellar: :any_skip_relocation, ventura:        "6d4472b72244cd4638d5817e6798b132203d33fb9de123ef13feadb75d43e9fa"
    sha256 cellar: :any_skip_relocation, monterey:       "c0ac87852bf66b8e60d08ce7ee18a0787d1088ac2d8f2d07bb0c578f825830fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f35775e6f0942280aee1d9e6e0857f0fdd0922e683af062c5e91f3ba7ab0ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f57ae13b354cabd2dd811831780e4fc425478795545b765b39d7f8733d3c7d"
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
