class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "83ff239a686e72c880a22d2f88c0b0f9402e0eca7e60e00e14bc9208cd51419a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48a3e556903e1797edb749ba722bb771d332e44b44c2f15461d3f7a017fbf920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41e7ffacb938c58cf1b492bd4e7f491fd833eb12b2ba70871b55af990a6bc257"
    sha256 cellar: :any_skip_relocation, monterey:       "2c755b30b3b52398140876d86dc2721bdf895a7a7ea69af41ec4942b98213180"
    sha256 cellar: :any_skip_relocation, big_sur:        "a74995ce38fc6c21f354e20bc788b586448c0494a932a83902f0abe8df662c2b"
    sha256 cellar: :any_skip_relocation, catalina:       "605bb223fa9b8e3eae06c39c34eb31bb69c72ae30662a631dea078ea0e7a7198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76af0c9eb71e3a281e1516d3a194716c472acc9cca59ca9cd89405762dfd6018"
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
