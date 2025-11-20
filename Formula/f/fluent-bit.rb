class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "44fe0f52e89a63b213695748f99691d0a6247a4bd05065f1b517c798d9f89bcc"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2374330557b039eb9eec439958328960d843c50f6a4c46b209ed8036891e8bcc"
    sha256 cellar: :any,                 arm64_sequoia: "e4404993a76d280571c7213192de1dbb268dd9e8e70115b9974f83e37c59bc3a"
    sha256 cellar: :any,                 arm64_sonoma:  "f3f2c36510c36d907490431ac36d3f80649d68392db079ffb6e1117abd2727c7"
    sha256 cellar: :any,                 sonoma:        "1e389c01922bae4e0a59f783d142a3684011c0c836db59f0ea5458f508add760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dc88f6854b797a9a910c1f150842c434956310643922026ef83afb859141813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880bc6ceaf0c16f43c7c0533b163817f1edfe240fdedd17eb96b0d265b8f0eef"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
