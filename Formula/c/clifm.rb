class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "902badc747aee1eb1a3a5556ff3fd9d83d2aa987d24e058024064df8a4b6b71f"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "606eee20afbd49cf30c128a1d67597857a9ae6b9571ade1692b6b47c127cc793"
    sha256 arm64_sequoia: "50da01bf2201fa1a3f38e3401769043c91d9a6e16447c84b69c24959be309431"
    sha256 arm64_sonoma:  "05c5608e9362190c29944eea4d20bfd2db6b9842e3b3ee9102157fe88c63c903"
    sha256 sonoma:        "745c6a4820bfe4a199910d16ca5ee9e94f477220950c63be83acae3d99f4517f"
    sha256 arm64_linux:   "868153da39f2d3707183b9f34f27149e03b0dc55ec37cda4e449c629d06ab7e4"
    sha256 x86_64_linux:  "2ec659b9dc72bf9dff2ca1842e8cb154e3eab97871f7ad11a249223555972083"
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
