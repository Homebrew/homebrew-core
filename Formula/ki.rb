class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "b5e38918ac64216713c64170fd12f7b2c7c00124ba8d8b10ae7e53b386cb4bab"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0add1f8631d7c8644d069e90448bc05100382231f4c91277da613616237c87da"
    sha256 cellar: :any_skip_relocation, big_sur:       "263c6ef6580c5f0b836a8431690c4d627aecf69e020e86390ed980106e04e434"
    sha256 cellar: :any_skip_relocation, catalina:      "949082f04d01689c368204a29438f13de6517c7053aaeb0657d4aeed0343607f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b41c9279a82d854134ec99e990e988a7ba7f16cfecb5e39f20d313c734299e"
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
