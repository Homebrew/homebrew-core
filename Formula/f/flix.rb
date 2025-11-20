class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.66.2.tar.gz"
  sha256 "2e16ea2a63677c080b37a1e2bdbc4912217c82556ab3eea721120b264e205521"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ceee027c273d848f6e765d691d3489ebac5ab22932330a7ad0ffbf8755717c34"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "gradle", "--no-daemon", "build", "jar", "-x", "test"
    prefix.install "build/libs/flix.jar"
    bin.write_jar_script prefix/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end
