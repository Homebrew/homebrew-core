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
    sha256 arm64_ventura:  "d68ecfe166abef4cc9548640dc48624a982edfc91419213981c00e1a9059de7d"
    sha256 arm64_monterey: "1cd96f4aabb8ba0393b2107e36e51595b41f9a6694e5c6b1016c4d0204aeb4d8"
    sha256 arm64_big_sur:  "9e11246c6cc06ce7ba3e128bb2d8a8d24133b81292c06cce4c9aae8f5c58d920"
    sha256 ventura:        "f36d123f6ffc3c6b4ad4a750bfdb423ec473f85f06580824853411755cef18d2"
    sha256 monterey:       "91333877eaa87d476f01c3a57739123b18ef7dd8bfc4b4e7a48a1df9e0c6bf7c"
    sha256 big_sur:        "5049cad2ae1f6859d6c6fa7aee3184f74efbd3c7159aea84b81eb1c07599bc65"
    sha256 x86_64_linux:   "98b5251dc93ddb30aadb2182801a1b02744e0a28b3f31d36ebca8734b29172c5"
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
