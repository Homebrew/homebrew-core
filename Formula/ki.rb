class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "5b65d784a66b6e7aa7e6bc427e2886435747cb9b2969f239d3be1f2190929fe7"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48be2a1031fc2bf7fdac348fb639a7d2feb6f4cf0c357b77a750d8c2c3fac901"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14cbfb27e03216a1e02e9058a30bc2ff3523fc2f29b00790a7fc3eb13b7148c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14cbfb27e03216a1e02e9058a30bc2ff3523fc2f29b00790a7fc3eb13b7148c9"
    sha256 cellar: :any_skip_relocation, ventura:        "cd8ade77bdf44028519583eb08717c28cabeaed469f70abb75f0458170525474"
    sha256 cellar: :any_skip_relocation, monterey:       "f218424013a975e865931fcc3b045a01665ce88345fe257e38e84c655cffd728"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c2eb51ed8339eb71d19bb9ed6a8ac3bd30056f2efd33a74d8078808079ae59f"
    sha256 cellar: :any_skip_relocation, catalina:       "137ed3bd1905cc0a60ef1d5433b9baed66ed36fdd0bbb60d2da6956c58bd00e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c1f7055c425eef58c5a15b1b838d54e15d7b4347ac2e85a28eeb7e42fcee46"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "11"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
