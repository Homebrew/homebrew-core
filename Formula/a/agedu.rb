class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20241013.3622eda.tar.gz"
  version "20241013"
  sha256 "3f77cb2e4dd64c100f7a7b0789a6c06cc16f23e7fe78c1451f5020dd823cf2f8"
  license "MIT"
  head "https://git.tartarus.org/simon/agedu.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?agedu[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f04708967fca0cee916a7361fc5aa4dd9c5bd3e639f1a1a9b83715d626e48d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d779cddebf2f281e0ac4ae36def487c0068283d2be92002709f23fd6f81d9d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a1e5993b600a5ed4625628cd50e19cb46f8761e374d4d6b28be5d4f021c873"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40c91107a019a0032e48dab8c7a03e9b9e30fb1b566940f09b59ed51055455b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e793caa2392c484df501763ba40a368adbd1a093c37558690bb747eb95dd5c"
    sha256 cellar: :any_skip_relocation, ventura:       "5fa2adc1d4d7d12ab15c411da797706c7d7e9179b18408fd4a69ffc00d314ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e65d93a8c50262817c010ea8f441dd820485bec296d7fb559a89f1765a88edc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ac7a445b632cb005add4e4d8a5aefeca4a537930de4c2638607ef3a1ed203b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_path_exists testpath/"agedu.dat"
  end
end
