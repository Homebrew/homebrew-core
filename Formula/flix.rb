class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "25a3874e3c58f96b858f48da83f2a3dad77d7b14443e8d38fde01b8c370e0e7a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02e27813591d1dfd993948ff0dc5a6d90accb6dad9ca9d3d68a2c543888264e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b2b52292ea56e4a7fa09a1a99128f964e15ec04169a0ad1cd42872da29ee15d"
    sha256 cellar: :any_skip_relocation, monterey:       "d83cc0f4f35d6a306f16cdaa03ce88a3c561cde952437087867263c79dacf495"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d1bff97e62ffc79e4e1b3b547239108e951ac8420856f977ccbc9d904fdc9c"
    sha256 cellar: :any_skip_relocation, catalina:       "35ecd13c24fa6a4277d656ffbe837f28af3d402e23dbfa781af763bce876ada3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4fa5a239e211a701543c844e4cfe712f8b33b07b27b0c51eb5e174e0d5eb8f"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin/"flix"} run")
    assert_match "Tests Passed!", shell_output("#{bin/"flix"} test")
  end
end
