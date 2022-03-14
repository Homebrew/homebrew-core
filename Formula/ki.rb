class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "b5e38918ac64216713c64170fd12f7b2c7c00124ba8d8b10ae7e53b386cb4bab"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9bd8431d24f78714d40f396b2b74429d1838e79a2ac5ddb4a2597c706d8d189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a42197b199084ff668ac35a7c3628b2c5e7572156197a3999361cb9ef3af9d3a"
    sha256 cellar: :any_skip_relocation, monterey:       "646c60b8c6f270e1cd2960a4a406609da30b82220a834d4ea9e5add38541e621"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b0a4d34508bf3a0770222f95d7cddb14f1011e609bc57ef8cb6262c6ae21985"
    sha256 cellar: :any_skip_relocation, catalina:       "e0801112af6e580c97ebf5691bb750e73279b8763fd4d636bce0eb6ffa9cf57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92fae01e885dbbc60e15c2bd7a032a2f296199abe37155e9be6007da3bb30d3"
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
