class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "21570f78c59fa9a0fa1182bf90b8491d40e2f40f84bb11adf6e6ab03ef7dd1df"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc371f75b84996462cf2d052ff71a75147b879176d1299ede9fc92e0d30472ee"
    sha256 cellar: :any,                 arm64_sonoma:  "69d9384b15a39a766af59af776757263980198180bea24337e7e9977c97ef2d9"
    sha256 cellar: :any,                 arm64_ventura: "cbea2cfb918dda67fca667cac4c9289ca4f14da418e8bfad65057665fa75e55b"
    sha256 cellar: :any,                 sonoma:        "40fdeb7a2c19d2a36627f3df627f40233547da7c6b9d8ea7eea4f2d0f7463735"
    sha256 cellar: :any,                 ventura:       "6001dfe1f15f581c0443ef15c8eba96ec463039ad686707d88e018d7ab663ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29a0aacc4e1e54427aaec78714c58414554a28df77b5e3132996995c3d202438"
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
