class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "5b65d784a66b6e7aa7e6bc427e2886435747cb9b2969f239d3be1f2190929fe7"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26acde25faed2e7f5f8758b91265387d3aafdcaba302ea74b67c87b390ff345a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f8535c44f8e69f9295957a28022182ca753a5a59eef6a1b0b9351c09cecc6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18939db349bc95a0caa3a38cdc577cdaf3e72ac19222847d0abc84026cfaac0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "da784f7cb6571cf655f53473e34d2056781727a9bd31d05eb809faa9a31461ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b42754a3d9e0548aed51278026c7375b8dccdcd5b0ee9c84f9211363be3e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fef66e2012700f86ed7c3bf130320fdc58d1362a0b681fe88862af169a8d42e"
  end

  # not compatible with kotlin 2.0+, https://github.com/Kotlin/kotlin-interactive-shell/issues/131
  deprecate! date: "2025-10-26", because: :unmaintained

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")

    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "21"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
