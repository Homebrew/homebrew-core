class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      tag:      "v0.3.5",
      revision: "5265a8db4b0fdc54a3d0837a7ddf520ee94579c4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfix.git", branch: "master"

  livecheck do
    url "https://code.dlang.org/packages/dfix"
    regex(%r{"badge">v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f65a8c87afac18f657ddadf77afc6ca147ab828d1ebc1ef82bc31812f5271e1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e09cac4fbc12bd545b35029aa83b21f18a1bdf6600c665948be746e2318a4ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd565bcd8020bb8e49cead101c40c649c85786f41c44eca815a740ecae973788"
    sha256 cellar: :any_skip_relocation, monterey:       "0102eaa83c680a6a425f8e532bfc00b5c611a86d14d1382617e3d6ae5c76a1f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb047ac32131d3ec25b60ca86e77959f7b9625ad469d9e0a1ada3fefe8525d9d"
    sha256 cellar: :any_skip_relocation, catalina:       "ff3b76977bcbfb5b7a04bbebb53a794cc522b64987f724fe5f8a8236812eb1f8"
    sha256 cellar: :any_skip_relocation, mojave:         "24d234e206efa754f8bd900102720280d8efb1af6ec93059a467589acddca3ee"
    sha256 cellar: :any_skip_relocation, high_sierra:    "13a2621737c198bd0540f507293a9b015a0ebe36cd3373589a69ec834a863d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18eaa549250f741f4459b82c5425b4378587006db96f83f76ffd3967df9eaefd"
  end

  on_macos do
    depends_on "ldc" => :build
  end

  on_linux do
    depends_on "dmd" => :build
  end

  def install
    ENV["DMD"] = "ldmd2" if OS.mac?
    system "make"
    bin.install "bin/dfix"
    pkgshare.install "test/testfile_expected.d", "test/testfile_master.d"
  end

  test do
    system "#{bin}/dfix", "--help"

    cp "#{pkgshare}/testfile_master.d", "testfile.d"
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
    # Make sure that running dfix on the output of dfix changes nothing.
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
  end
end
