class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "a35cd1ccbb83f1261c3c5b14b5b4733cf0555be68579b3cb19fa8b36076a5339"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "57b22f3e5ccc6a47ff0ae609316cb70e099ea9536cdc845b7f64435e926b9dba"
    sha256 arm64_sequoia: "8a456c9d776ed4840f9861abf2ffd40fecf3023819ba836c1e0a5d429e0ada84"
    sha256 arm64_sonoma:  "e56237bf0604fb80a5e236db4a9dabd999c1274251e7516f028295c47a0c2569"
    sha256 sonoma:        "dab5a2b5bbfe40da5398a239c0577d82feea49ddf7b2a31b7d593c80b5e9ad6f"
    sha256 arm64_linux:   "887bb3fe8a1292820efcd91ee00bc09fb4d130b54be2d3040d5b3210627e3523"
    sha256 x86_64_linux:  "938a9debf2f00b7b72fb9f59e83b6c923278c89746352046367dfc9deee6be68"
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
