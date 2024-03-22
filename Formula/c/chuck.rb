class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.2.2.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.2.2.tgz"
  sha256 "c438bcd5327fa61aca2883f05dae3efa5583e65ebbedf3ad118c5d2d2801e283"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f66dbe5b8b9d9e2f98f837d21e955a40a50d8b1c561d4268167f95d666399fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6144e326b3fb27bc4072de4ac330870d6ef62d06f21bdc31a6f03107f4017a5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae4a2d90c85b89ae8de2f58aa8c1c5418fbea0c810eb1644dd5e8c3d21333aef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a4a0873b81e5ab8b99982b9f09b558477bf4b77ef6b1f7bbac12054e4ba319d"
    sha256 cellar: :any_skip_relocation, ventura:        "fabf66ee301253377058f2ea787d7dc91f5ef9fda9096d823b2cbfa2f63e91a2"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4d259f948db7f15e5bde43b9b3f514272bf8386237f27bdd6ffe74766d605b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d614e5a0c0f8c9c0d7301b9d61f4b737588523789537e1d6e9281307024741"
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
