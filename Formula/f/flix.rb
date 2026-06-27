class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "93188f882a8f0e90391f30c89d20c9e82ae2ead587155611eaf7cc4bcf4bc67d"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "561d9c7ae105bc53b59a0c6bd7c8aafc3fc8e1981bdb80975350916ca7223c16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4193e0e25554aef83dbbc4202af131ac133c99cdeeaa24b205ce70b4dbba92f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620b3242c23627854dce56108ac8a18999582e1d626baacf5ff073420d39552c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbda2775d115105389262751e53098296518397aeb4db06a1c681f4c8d4b1b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17e30f11d4be2af35fd5d37609da240376a382a76a2be10b106b57df1c64cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7322ea54483ee9d1e777bc371fb1540251d56b56f4a8e94a9a4d36646a993334"
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
