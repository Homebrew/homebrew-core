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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a21dc5b6d22a47b2d75c0b49000e41c5cf0cd4ee1652e022811d933d29c58dba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15c2a2091f8e419197cf809133d7f1a37193fc30adbcba08478536c6849533d3"
    sha256 cellar: :any_skip_relocation, monterey:       "bb98268287049bd4d58d4363504397d7f7b1ea0c86b0ca9a67fb862ade5b977b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea9f98326da1a6fa70b39c2170cbcc93468a2c56b82c3dceab4769a91e482713"
    sha256 cellar: :any_skip_relocation, catalina:       "42863b95cd346c9d9a08e4c8afbc17857aa2b5ea2ad324c07c198a28ce3aa4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09652d717ed633bb13cc2e81775cfa308f7a85e5adba009d99c921970c43309f"
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
