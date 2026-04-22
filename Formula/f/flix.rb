class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "d7e90a19e6d9812c7eaf0a844f621ec1c1d3039c36556f192273898d4b177dc0"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac3971fd083afecc49000b03c737c6dbf2969d4dc6a15815626e1ca659a4391e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "074591429f2e7f54bc6860e003a25d70aace9defe692d714887493a31e3c7f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "881e59d42e615bf42885e030d0655c5e90c0ff708f6c0dd4ed0d1c119d60a031"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eec9cf5d8552773b791b77d0909f402e3375709b5351f1e184142b6cc224132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea67e5290284f687355db81e407e56fc8c4051a7643474fe51f15fdf9ff5f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df34e37e0475566e6ce1d82b73fe2a6eaf9ee8ce369aba677414d35c330fb42"
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
