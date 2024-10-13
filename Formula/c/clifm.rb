class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.21.tar.gz"
  sha256 "cb219ca6ce1b4a31ec98701a43da51142c8bc7f15a22cb81dda93f881e6f6877"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "813fcf5ca1ca698994f1a9676006a8994537493da00d3f04b853148d0a0b956a"
    sha256 arm64_sonoma:  "bfd80b3ac7618b8fe15cb4fabe6a08f8e5d5cdb9e3d258a7def151c8a03f3578"
    sha256 arm64_ventura: "6c0b56d150377237acd97158ef4a053abd9976231478416a77a75659ab92464d"
    sha256 sonoma:        "8045b1e47890e2967a5bdc07a7b69bb9059fac00a566e7b3543c85fff6d39028"
    sha256 ventura:       "d51436543ac15d87bb2413a94e1d5e8bc24167b00cb439afbaced448a4324b73"
    sha256 x86_64_linux:  "15fe4caffb4840029995eb9cca88563e2bbd2b2997b3eeeca11fc6d9494ae3e9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "libmagic"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
