class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.10.tar.gz"
  sha256 "aad5176cb4dcadacacd379ca43160074c6690012d37c4749536ac3b977d50495"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "0463fea8a38a358abccc5194f9fc829dd5e406f10f94201349c8df4ff112939c"
    sha256 arm64_monterey: "4cca4e925adc910fcd8a32b9e5e6167c20e27d43142b0380c67807f8fbac1f1d"
    sha256 arm64_big_sur:  "4ff5023587bbb7230f341e6a5b9edd046fb779aadff9e4e9c92c1af4ac8b74ee"
    sha256 ventura:        "613a3cfd4ca024c1c305dec08bbbe6101cc50b6c89af48ef26b3d0a7c8cc1318"
    sha256 monterey:       "13bc4baa31c2bd8ab8da89cd1f2405803bf9b291e672c62fefebe014cb54714f"
    sha256 big_sur:        "3a0c14a2533306840ebbc3f5ed4375469d047be9f7023a3afab9385321acb27b"
    sha256 x86_64_linux:   "b790144b4e472e8cab875fb13117cf47cc2d8dcfda6792bcbed1207587a435a9"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see fluent/fluent-bit#3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
