class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20230323.tgz"
  sha256 "4f599c4f774c7accfc78fe07a2d492f2352c7b5ed9aa03f39b74f39c937b96e6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4aac235495fe859eba9a955a21532be0eec6ff8fafbc60ad3b125579444eae9"
    sha256 cellar: :any,                 arm64_monterey: "557651b31ef704c6684028639eddbc6d98116cc14c551aeb58c948ed5cef8fe5"
    sha256 cellar: :any,                 arm64_big_sur:  "b9cd7a728c67f0cde031da717764921af4fd9ed400c89b6b57b76b9f8ba21813"
    sha256 cellar: :any,                 ventura:        "a51783ee53c4d04b4129dd79aa2eb1602a1efa64571364136450208420ea859a"
    sha256 cellar: :any,                 monterey:       "cbe0701e22a84bba98d73230e2dbe6ce47c5e3f4cc4f3368e18ad5fa053cd8fb"
    sha256 cellar: :any,                 big_sur:        "72117f54b1ca2bb2bce8ec1c1f668f84f6abad15e3e2d6239f96b05fef5be66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35734ea2d7aa31c1941b6adaa5b554cb4b34a0a18f7b604e0dd003987ce358f6"
  end

  def install
    suffix = if OS.mac?
      Hardware::CPU.arm? ? "_arm64" : "_x64"
    else
      ""
    end

    targets = ["hdhomerun_config#{suffix}", shared_library("libhdhomerun#{suffix}")]

    system "make", *targets
    bin.install "hdhomerun_config#{suffix}" => "hdhomerun_config"
    lib.install shared_library("libhdhomerun#{suffix}") => shared_library("libhdhomerun")
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
