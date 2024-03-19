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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dab5596335f7518472d59394a3e6ee33067cf5de3dc1705ba92d97348190f06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab5596335f7518472d59394a3e6ee33067cf5de3dc1705ba92d97348190f06d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb8530fb1c281f897ec79d7b7c34c8b9ad8abd07bf695c4237d4215ce3e4e89"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e4514426ae9b93a16f8d310e28eb45b55e7f9265c19e6060dc044d9359bb2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "3e4514426ae9b93a16f8d310e28eb45b55e7f9265c19e6060dc044d9359bb2b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e3de21a5c613e4578baacdb37d5df90d2b1216d4a966873bec817609f3f135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a558eabfd22c8c7c7358c33adb58827dc214f513428f66a50475c25abcb598"
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
