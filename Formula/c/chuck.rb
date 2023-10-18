class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.6.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.6.tgz"
  sha256 "bef09574706bafacdfdbdb221368447dcfab37d19e500721e29e44fc782dfe2d"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cb0d633a63de706bc6a29111373213a6373c8578e8352a533cee7042c7ddad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d83d9b1a5a72245705bb68d5b53ed551f91d6ad5a84ee72d4c6f9e0f3eb7e9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1316d485d529e5ea9a7a96bbc6550f36e50074401d75cb716e4c1e2ef2011a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cbde5d9ae3182d578f7aa3f4bfa0a73dfd092c56321d4ae5348184b0a16e7d8"
    sha256 cellar: :any_skip_relocation, ventura:        "141a021be354f73b81ff1eb49fda55ec4b9cc9872fe070863268fab8669cb468"
    sha256 cellar: :any_skip_relocation, monterey:       "9c6b90bb522545546b8a10701df2737376bd26fe14fe385cf51df779129ed9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c4372e46c68d49426478d9dd10126994d0e434081554a24c64a95f2904a1f50"
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
