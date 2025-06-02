class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.4.7.tar.gz"
  sha256 "f2f42812795ee73983e82c199694728576409b02fefae478a97f4a0665806685"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3898855e88a64cf84418efcb37f2c7fff1ca49aef3aef9ce0b3bb7ff53c6ce7"
    sha256 cellar: :any,                 arm64_sonoma:  "f07d78595eb1dbf6effb7f8db9d7d1ee1b28f5cd63997f9516fdbc6336643c26"
    sha256 cellar: :any,                 arm64_ventura: "e1128cfbf515da5300f202b85d1cbf617cb7d6a5e79655c322338501cb5b9d3a"
    sha256 cellar: :any,                 sonoma:        "8ac1fd11747938010445d3d751bc238a752d9d6d00a0173630c628cf4bf82225"
    sha256 cellar: :any,                 ventura:       "0bc32bd0e5d20c341abd0f058320640eac72e7a8bfe4ea1520e057d418b812c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b88f4c966cad83dd7afbfc3e6024057f8d9bee964a048efd4875458dd0402133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a47df2c6511c56a2713c084c1351b76b4937cd782b93211d4f9892e8430fec"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "xapian"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = []
    # Workaround to use uuid from Xcode CLT
    args << "-DLIBUUID_LIBRARIES=System" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".nmail/main.conf").write "user = test"
    output = shell_output("#{bin}/nmail --confdir #{testpath}/.nmail 2>&1", 1)
    assert_match "error: imaphost not specified in config file", output

    assert_match version.to_s, shell_output("#{bin}/nmail --version")
  end
end
