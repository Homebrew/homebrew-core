class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "81804a0663d2ba79a034bc62422ca242fcef6dea793a8bc8293d0f596affae07"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c387fd9c614f8a31ca0f7768df223d076a7c8986c0193f5da1d573b34d2b0d8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f7aa069977eb88a51bd957a14c2a501586da378addf726a78689d8ed688c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "40ed2b53ba0b0f6dbe03645e9b8a1b7296d7dfcb31884795f1fe0bab51f3d269"
    sha256 cellar: :any_skip_relocation, big_sur:        "204c13b6c32b05d82fe7ab558d4ca11d109b6f6fd246ac15f3ffe955483ee106"
    sha256 cellar: :any_skip_relocation, catalina:       "192a66dea56af109df582b2460e0630bf4abf278f6233782ca91c21e5b8b275b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5f5829e6a9e498de766545e5a9bdd054b5c89cbed1416bc9c06512c7da16f2"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
