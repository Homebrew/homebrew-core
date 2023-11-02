class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.23.3/detekt-cli-1.23.3-all.jar"
  sha256 "2e6f73f1707b05d07b8a48b2272b95b55f1eaa53ee73198c34d0bdd04f7daa90"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fbd39855c01cea206ab8ae3c0e4ec540705ad88c8c53049c83e823fe4ac4603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fbd39855c01cea206ab8ae3c0e4ec540705ad88c8c53049c83e823fe4ac4603"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fbd39855c01cea206ab8ae3c0e4ec540705ad88c8c53049c83e823fe4ac4603"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fbd39855c01cea206ab8ae3c0e4ec540705ad88c8c53049c83e823fe4ac4603"
    sha256 cellar: :any_skip_relocation, ventura:        "4fbd39855c01cea206ab8ae3c0e4ec540705ad88c8c53049c83e823fe4ac4603"
    sha256 cellar: :any_skip_relocation, monterey:       "4fbd39855c01cea206ab8ae3c0e4ec540705ad88c8c53049c83e823fe4ac4603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247ca743cee104509459e3525f01b9ce6d40c5a279cd2044aba532efae4beb44"
  end

  depends_on "openjdk@17"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    # remove `--add-opens` after https://github.com/detekt/detekt/issues/5576
    bin.write_jar_script libexec/"detekt-cli-#{version}-all.jar", "detekt", "--add-opens java.base/java.lang=ALL-UNNAMED", java_version: "17"
  end

  test do
    # generate default config for testing
    system bin/"detekt", "--generate-config"
    assert_match "empty-blocks:", File.read(testpath/"detekt.yml")

    (testpath/"input.kt").write <<~EOS
      fun main() {

      }
    EOS
    shell_output("#{bin}/detekt --input input.kt --report txt:output.txt --config #{testpath}/detekt.yml", 2)
    assert_equal "EmptyFunctionBlock", shell_output("cat output.txt").slice(/\w+/)
  end
end
