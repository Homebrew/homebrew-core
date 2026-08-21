class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.75.3.tar.gz"
  sha256 "453d5d7a1c183ed68b51988dfad7ec2eb68b3a1f3a62f2009ef9f5634bb3600f"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bd414a8b6eb64cbc74e0245ccc1ea5abadd1b97bd074363b496c356934c1b2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d51c947530650dd3f95cc3f903c36b0a20e8bb9592985770b755511664771c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda39dab991839aca38eb222e6ccd9ffaf1e94864ef4da58ba6dc53dd3024530"
    sha256 cellar: :any_skip_relocation, sonoma:        "daba37ea8474679f25ba86dd6f553743f3c70164dc3173e2fc7a556991747952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209f9a9f269b58789dcd3bca784decd9de26e30ba124edf979e63807da28c0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e839a50eb1134270f0c52a0ede56004e8fe29dceab679912a1bb8d0439bbea"
  end

  depends_on "mill" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mill", "--no-daemon", "flix.compile"
    system "mill", "--no-daemon", "flix.assembly"
    libexec.install "out/flix/assembly.dest/out.jar" => "flix.jar"
    bin.write_jar_script libexec/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end
