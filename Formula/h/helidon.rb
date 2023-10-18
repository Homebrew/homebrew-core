class Helidon < Formula
  desc "Command-line tool for Helidon application development"
  homepage "https://helidon.io/"
  url "https://github.com/helidon-io/helidon-build-tools/archive/refs/tags/3.0.6.tar.gz"
  sha256 "749cf3fd162bb9449ab57584c0bdf8874114d678499071ea522c047637de0f90"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea90290bff83311c06bd73947a5b71f3784751280d7e4c6eceb3e69af48523cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0913524edf79cfd329a2c305a2546e3de696eac9052d128793dc3d520276292e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c56f16a9486e5478d7edaf8c3aa831e8fc0a44198ea75e0ff5e359d605f904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e15cca7fe3db16ea49e9facb7f843980500389f67d29b197f928a3bd0e237045"
    sha256 cellar: :any_skip_relocation, sonoma:         "13d0ecf70e2d906f957dd2ad82583757e54fcd5fa5c6f1449d622051369d3878"
    sha256 cellar: :any_skip_relocation, ventura:        "3b33c2c23aae9eec5109afe7b7c5c9504595634839e0936ebd97b17c327f8df9"
    sha256 cellar: :any_skip_relocation, monterey:       "bea2b19e951b9aa623ef444289e4907c408a9b68de7120945f04eb3ccdd7358d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd91517ef7641f9b12502765cc8769b37330ee355e01c5bd26fb56d6e993ecc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce08913629c3189e1b71827ebd5b5b0db3919b1eb75a1ba824e2ed25e5aa27f"
  end

  depends_on "maven"
  depends_on "openjdk"

  def install
    system "mvn", "package", "-f", "cli/impl/pom.xml", "-DskipTests"
    system "unzip", "cli/impl/target/helidon-cli"
    libexec.install "helidon-#{version}/bin", "helidon-#{version}/helidon-cli.jar", "helidon-#{version}/libs"
    (bin/"helidon").write_env_script libexec/"bin/helidon", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"helidon", "init", "--batch"
    assert_predicate testpath/"quickstart-se", :directory?
  end
end
