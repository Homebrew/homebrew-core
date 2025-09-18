class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.2.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.2.tgz"
  sha256 "b732707ce809dbc907123ad0f00e3f2b6a4683c43ae6b4f66d2fadce6de3e5b0"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "519c0f687ed88dc618c194014d366a3dce37c150ba779a8762be189fef0e6a96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95008f936f0e3d077044fbb4e19f39e8c0f1d2d5ab2ba6fd6ad979d60bf79390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9560c3c7ffdbd85a1e37f3074aa62c90b36fcee4955a158f5c0af3da8404bbcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e818a126aedadba25538a6dcc60d91b1cf054391754ed229e2e5a223e9adbf70"
    sha256 cellar: :any_skip_relocation, ventura:       "27176ce952c27f3eea966576463348ed41ba9bc7b517f4ef2846418be8b3d0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9845f1d4f527f53d056f8790fd91ddac84a25e5b5cd9a995b6dc311b4d3ef419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81875d81a4cd73e233e24fcaf5565a86888a35e18fd9cf7b512e33dbe980b991"
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
