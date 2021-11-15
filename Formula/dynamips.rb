class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.21.tar.gz"
  sha256 "08587589db2c3fc637e6345aebf4f9706825c12f45d9e2cf40d4189c604656d2"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2733d58e4e92ebbae4458cc3a0c5af500bd007ede953efd29db7850cd6ddc5e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b25a7870e64febcdbe828bd72f0f7ff29acc43a23267ec07e316b3ce6aea0763"
    sha256 cellar: :any_skip_relocation, monterey:       "391e5fc83c27da6bf5203131f5c284c93b2af9ec036b999c21df4a23ec25d304"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cf10fcefc4f6d8d2fff03b407e0d8b2730ef944c9d91762823ca1865b7b3f33"
    sha256 cellar: :any_skip_relocation, catalina:       "ecf536589504e42389e91865495faa4eb30ba20adad56bc865c0481e80abefe4"
    sha256 cellar: :any_skip_relocation, mojave:         "db5398464afdb11af6f26cd4780f6e688bed0f35c9fea8f8308f11991987a037"
    sha256 cellar: :any_skip_relocation, high_sierra:    "cb9bf6eebd6a7987976e0e2543a807e1b0f16698a1c71eb64e7da56f320fd425"
    sha256 cellar: :any_skip_relocation, sierra:         "08b44502cd3b052592f11f5b75453fabd51fdcfe1a311405c4b7329a701dc424"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  on_macos do
    depends_on "libelf"
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    cmake_args = std_cmake_args + ["-DANY_COMPILER=1"]
    cmake_args << if OS.mac?
      "-DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf"
    else
      "-DLIBELF_INCLUDE_DIRS=#{Formula["elfutils"].opt_include}"
    end

    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
