class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "eb7be2a459b89b62b125a285595377a73827a021c112d7faa41ca4759d457565"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d44d3a85a124b8f080aebaf3ba8cd5b0b9c6c922d21ba49b695be3957f878f4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c8655431d8e95d4bd70c2962d6ac12435b5e452ba5a11136e9eb54b1d4ca791"
    sha256 cellar: :any_skip_relocation, monterey:       "79fb1ecbabef9994029dbe66ce64ced53cdf2d07ad687a3f1fcc7d11edbf7730"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b4357f01b1ead0cb9d6af4d89d53b850b648610121069ff8200aa30f75cea1e"
    sha256 cellar: :any_skip_relocation, catalina:       "e33c5b94f8f3f1adadf1d0f8e0d189832c19202aef01f792e3104128e067777e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c64a80278d2845df6f7ea14314fcb93471438d7daaaed16e5ec032de35204d0"
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
