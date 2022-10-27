class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.9.tar.gz"
  sha256 "d58dc649f6b4e2433711666ae68c8f443c0542801eb6241b21d245fb421daced"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7057398627dc69681a1373d71e3bfd7efe66b5284b4877e040c7e78a370010ec"
    sha256 arm64_monterey: "38b8a286d68ddd1f05105fd7d87340b0a7f1edc5a54aa898b237f8696b97d633"
    sha256 arm64_big_sur:  "aa51aea33e52ce6ab0317ee8838afa26865e5d2feab8592e8e9f9d43390e9cbf"
    sha256 monterey:       "b081c17bf3ab57f6f397a8cc73e8dd031ee0c8271438887b783ebb748da5862b"
    sha256 big_sur:        "edc05d5b1e08ad65a93e011dfeee70b03ce72cd4bee1756491dca1fcf0028346"
    sha256 catalina:       "8ffeb69518b31fd646800b5abc989c136ffab6e2c8a42e2ba6abcd969e351a27"
    sha256 x86_64_linux:   "b88cddcce029d0b5d028e19bfff9c25be353921c5456450f24ddcba9a58874f1"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"

  on_linux do
    depends_on "openssl@3"
  end

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
