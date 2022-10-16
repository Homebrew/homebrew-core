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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f02843d6799651851f731710e15116982a09d2613918878034cdd963892aa5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802c36b21f5edb9cba22251823889f0d83fcfba18bd09a17718c0233298ca35e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e9e470dfd1beba104410b913fdbd6172a8df65abfe67d949cf24a96e9963c48"
    sha256 cellar: :any_skip_relocation, big_sur:        "73ff62d0f7ee4e83665449a5e062d04307c549ea2fc44a0e613015465727cc84"
    sha256 cellar: :any_skip_relocation, catalina:       "67ca73f578548c592d39d5f39baa2d0054323df033b85e3b466afe4cffb5f3ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ecc8132574f5650842b8301641465d88c1823bc09ca8d1fc3f7841a097f1c7"
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
