class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.1.6.tar.gz"
  sha256 "4019e874670628ee0813fef7ecc92fc9050b1e42a74bc34ec0ba2c1e7efdb236"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "17e56cbc3e565852c955eaf7a2a9609947d16a37ad7857b033a7798b9f31949a"
    sha256                               arm64_monterey: "dc5cea210fbfb8a3388bb7ba35b4fa00e5916243fe83aa3a0b310af36e83250b"
    sha256                               arm64_big_sur:  "12512914f7d22176df56a7076239740fb767cc0a147f4f867693db56be509f8a"
    sha256                               ventura:        "77e95fa4d43224037d5fe759fc2a6badaa4d28f8d4f3acf39e09014477eefcab"
    sha256                               monterey:       "426c9deddbce304ca77afffe6fceef2dd1a38657a9614356cc84a1aebbe1886c"
    sha256                               big_sur:        "04faf17f883e089a32da52d1396280db2de829e4a27361083832b67523bc64f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c2c5e45091977fa2bf6e80e8332d65c37684b2ccf87b52b2fa7c9440b8364e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
