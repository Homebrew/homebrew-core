class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "7d073816b7db1e67ce7d374e898b3c1f859a4c73d0b768a9af0beaaaa2f087ab"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187a0cac52a19077a327ccbaa51c27b857d5ca1e4bfab260a80c5e07467c22df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd0f9da98c0ee50ac3d1fab3bfec1a54b5de3454accb57e6f4f30cf70494938"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "467c5359f86cb0c9a4fc00878a8788dfb80de5f1b32a3d0e9bef2a7e561697b9"
    sha256 cellar: :any_skip_relocation, ventura:        "082ec97c91884c3bc84472cd8483aac7785e1e5d5da657ddcda3cc15b77c4122"
    sha256 cellar: :any_skip_relocation, monterey:       "5d670cf3b47a1366e8b9af3a501a626471c733969f559da4cc089780b6016f4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0faa9f4641d784655f001366e3cd4cebee5015103c435895bf33adc0b6b0385c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd9de02e2bb8d678b8a4691170ffdb55be9e359b214ce9c6fb12f3a9c3fbe66"
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
    assert_match "Running 1 tests...", shell_output("#{bin/"flix"} test")
  end
end
