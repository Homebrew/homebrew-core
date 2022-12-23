class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.8.tar.gz"
  sha256 "8ff5566389033669feabc9c69a5c6f417dad5c8b066454388e6a706507262acf"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "76c1074094b3391c4ac6154c9c7c9266465e1850338e543b59d4091e6ff004ac"
    sha256 arm64_monterey: "af77ea7a9f86ecd7c9a6ea61d5b1ca9667ba1670c82e27d3fc7a8ee36bb60479"
    sha256 arm64_big_sur:  "2e8ac5ace779e4b62eeaee48a6c33ca25513aad9c4a34d4965c9a0469ed7b66d"
    sha256 ventura:        "f32d9112e1d6c6bc433ea722c5169b2ff946230287a9eeff4cfa30a495111cf2"
    sha256 monterey:       "0ed077898bdefa34e2381b0985bb704635b85090486f5b25d461a37b427ea10c"
    sha256 big_sur:        "319dfc9d55d49da8f0ec69c1f1e9db37078b19d3c2d5b324b523af25cfb1149d"
    sha256 catalina:       "a14ed08902a2b1c3a305736b5fc317d008eb2dc27ed6b855e562f96589dbaad0"
    sha256 x86_64_linux:   "57147259e5f5ed6cc368aa5e509b8d174edd24b7f432116be376f9b782682367"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
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
