class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "5b65d784a66b6e7aa7e6bc427e2886435747cb9b2969f239d3be1f2190929fe7"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4f17d3db413634dc6b07e462760db4358c8ec02012342c3048c52728ab71888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08da91f35d7ce64edc948fda63ef969592e9e299c2fe713559b300cb95d73f57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34f86ba275df07618724236322138b5b53027a6c4b772e178660460be2362cf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "39be21332141ebf86fd1b73ba0d6bfe8f8dec07caf5ddc8e8d9734f513681c5d"
    sha256 cellar: :any_skip_relocation, ventura:       "f44890a5523df5d74707bdedead4d8c617cbddea01322d541371235b878c402d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cc92adaeb7461ca30e6ae9a0fc64724d8ea9ed6a31717d2a7f7919c3dc9981f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c23ecade167e9a2e175a6b34693c45fbbd2b7b4b9565554aa34ddcf1988d74"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
