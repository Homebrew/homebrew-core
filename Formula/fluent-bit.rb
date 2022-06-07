class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.4.tar.gz"
  sha256 "82581ca093f87fad9ed5045ed69973ed45cb4a3aea67f74868543e722a19dd61"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "37663421e9394d11d5eed512f981e0d70323de546d40cb10d0b4b54b1d5e289b"
    sha256                               arm64_big_sur:  "843b25d5cc568b1561cb6616be0184c770dc47d408395e9a6b19374a846ffad0"
    sha256                               monterey:       "289f3f4a408c18a229667e46c2154900870da37deb9510f8f67f38bd7ae4dd3c"
    sha256                               big_sur:        "602d19b3b6ddf5e6de8e3fd106d9235c8fb8624f6dd8816d9b7a5d14e99c5773"
    sha256                               catalina:       "8f47526ba2708b5603c31ec7792b881563485b97fbe819b851c20f35ecd1ba28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9637360d790a464671d3294ca5579b0470e43eaab0866ebb94163672fcd62e27"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    chdir "build" do
      # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
      # is not set then it's forced to 10.4, which breaks compile on Mojave.
      # fluent-bit builds against a vendored Luajit.
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
