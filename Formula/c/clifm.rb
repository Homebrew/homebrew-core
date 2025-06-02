class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.25.tar.gz"
  sha256 "ac9156753338f6027d05551b1d02bcb6f3044348108b00b9cefd97f125fc95ee"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "36b5b6e72954845322fef4c352eb46ed4b73a14f1933d6ec355c1e2b3e986e93"
    sha256 arm64_sonoma:  "ab5b40d9dcb14253eafa522456927c3c267237652245df532afccadfd4718889"
    sha256 arm64_ventura: "565bda150a46b1a93b744e8127b6846dd07771aa889354d20e4a2ff981c55faa"
    sha256 sonoma:        "db7baa0c7727d78e7e6df1a8462cc6f59592755de74b801d99e5698b9aac2bb8"
    sha256 ventura:       "6efa30ac11ef6bc2bc490deba1a77488dad16a66d7a0ea4a9e454f6c84ab7751"
    sha256 arm64_linux:   "6ab562f2545c7a06f528368551c5755c9f5cacb382a4e4c5c053e376368077d9"
    sha256 x86_64_linux:  "0870af884cbb6934324c77df03b867c7ca10a2602a0ff926212cd418194f898e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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
