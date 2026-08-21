class BcGh < Formula
  desc "Implementation of Unix dc and POSIX bc with GNU and BSD extensions"
  homepage "https://github.com/gavinhoward/bc"
  url "https://github.com/gavinhoward/bc/releases/download/7.0.3/bc-7.0.3.tar.xz"
  sha256 "91eb74caed0ee6655b669711a4f350c25579778694df248e28363318e03c7fc4"
  license "BSD-2-Clause"
  head "https://github.com/gavinhoward/bc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa3bec57b187a0ccac9514b08d6782f93b7090917598f37c1f6bfa1ba21bcb9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c25b6baed11d3e111039ea04100d211d37874750f42e2137d78e7774646e06b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68e9138e7ca909ceffb94ef103feec58eb0c6fe84f315dc290ee3ad41597f163"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60a78a50e4599775dd214f3c04662a918f0ca3ba7a4329e55334b8839f746bb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "523f2085ce15b58bd77afc8324da625747be012b5706135c567d51a45ce906fb"
    sha256 cellar: :any_skip_relocation, ventura:       "ac2490db545515f79aea51d3433aa0bedef36f220fb0948851921c63cf5d82c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3c909b75dd473d2d9f9e7a266a485c23867721b4e1c08b41c68225ceccb5ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d223ee8690ef3a798c6c342faa78b304230ea30cb4957ce7e06b89fc213866"
  end

  keg_only :provided_by_macos # since Ventura

  depends_on "pkgconf" => :build

  uses_from_macos "libedit"

  conflicts_with "bc", because: "both install `bc` and `dc` binaries"

  def install
    # https://github.com/gavinhoward/bc#recommended-optimizations
    ENV.O3
    ENV.append "CFLAGS", "-flto"

    # NOTE: `--predefined-build-type` should be kept first to avoid overwriting later args
    system "./configure.sh", "--predefined-build-type=GNU",
                             "--disable-generated-tests",
                             "--disable-problematic-tests",
                             "--disable-nls",
                             "--enable-editline",
                             "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"bc", "--version"
    assert_match "2", pipe_output(bin/"bc", "1+1\n", 0)
  end
end
