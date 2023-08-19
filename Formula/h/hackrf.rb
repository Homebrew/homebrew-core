class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/releases/download/v2023.01.1/hackrf-2023.01.1.tar.xz"
  sha256 "32a03f943a30be4ba478e94bf69f14a5b7d55be6761007f4a4f5453418206a11"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e3a08883caa11b3efc07014bb53cac7f5de322b2eb2a6e3e27bade295b1e6f7"
    sha256 cellar: :any,                 arm64_monterey: "ec83b7be635e119651ee1715f6efa57c72d4d98f560e27fbfd4456598ab805e7"
    sha256 cellar: :any,                 arm64_big_sur:  "60831932de8d4499a1f1c54f1810d001ab3b7e3af0732735dd5e3df5a93ab935"
    sha256 cellar: :any,                 ventura:        "99bd5f158dbb6d6ceeafa5eb0c53b7bf91cdad7ace7bdd2c3102022b130c6cd5"
    sha256 cellar: :any,                 monterey:       "b21f730ddf1a1a8b117585bbf9beb271c73767fe3c69d0a7bd84812cb0256bfd"
    sha256 cellar: :any,                 big_sur:        "0c8b55d2e955787afeccdbee0ce02e168d35c3d72be0b7c627f9e9dc693c0f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0ddaecf5f1a3b3422c029113568f8fc5f04a5a3b72a0dae20b47da8e210a2b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    cd "host" do
      args = std_cmake_args

      if OS.linux?
        args << "-DUDEV_RULES_GROUP=plugdev"
        args << "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
      end

      system "cmake", ".", *args
      system "make", "install"
    end
    pkgshare.install "firmware-bin/"
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
