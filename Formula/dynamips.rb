class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.18.tar.gz"
  sha256 "39b8ab22f410d56db3161eaf7a16a70cf55aed200a7ac53bb737c71f34decac0"

  bottle do
    cellar :any_skip_relocation
    sha256 "31e69dbc45669d9f354f58d8743259f4a61c7db6ec853fcb370f64f45acdcf80" => :mojave
    sha256 "2be862a260ddf2ef632c6030412d54c2ed0744bcb45385390fabcc191c0765a7" => :high_sierra
    sha256 "eb641e0fbad0c964571f22371c200abce479ae26a722551303e015db61600a49" => :sierra
    sha256 "a6a7863cea9ce3666dc90117f6bcbbf81e1b97a2e6466a3760e83c1b72cc6dc1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libelf"

  def install
    ENV.append "CFLAGS", "-I#{Formula["libelf"].include}/libelf"

    arch = Hardware::CPU.is_64_bit? ? "amd64" : "x86"

    ENV.deparallelize
    system "cmake", ".", "-DANY_COMPILER=1", *std_cmake_args
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "install"
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
