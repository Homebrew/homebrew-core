class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.5.tar.gz"
  sha256 "ce2e7e108360ea74c654833bbb10cdd15c1dd312ebc190489a4743167c2ac50e"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "4fda9425fec296cedf5c4bf6d56377e32b0652ab199adbc5cbf108cf7491cb99"
    sha256                               arm64_big_sur:  "cdf11c5be20a40cc06150aaa96e1f4670903f1deb9fcea6e5e3df3007039f48f"
    sha256                               monterey:       "abace34e221623bcca622d4e57e6a5cfff53e71449e810b6754bd61ccb7574d3"
    sha256                               big_sur:        "28c42d15ec68a8d878f32f84fe2e8ede352df49fe36ea4a869318c4d84285443"
    sha256                               catalina:       "88a83cc66b0899be94c43ed5c2674c3e08e628be053863fc10c46861e1d4bf9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90632685a08fd2100692a141810984660b86f6a12e131e2241ea472717167fbd"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"

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
