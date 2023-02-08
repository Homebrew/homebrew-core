class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.4.tar.gz"
  sha256 "2b5db2f847a42aedd14d2338c6875a37a9cded210a1f0375f9c4bfef3b4dd677"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "643acf5e750054fbf6ddf8febf33661cc508340ee72025f0edf9575f5cab9832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404d71d9643acaba86f5b60dacfd2bfb3cbe052d8049f804903daa8abbf2e55d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b1588e8b6558debd910cc8f2def28ee197cf79b8d613f664ce08688810144fe"
    sha256 cellar: :any_skip_relocation, ventura:        "8915ec179f290aca384924001e86c1a32d3595f2ed465ac07612f38cdd19e18a"
    sha256 cellar: :any_skip_relocation, monterey:       "694ef18ad890a1ee5405c0f7539c4d475fff90d4f424ba1f2101d4c18e2783e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "808116846843d276c2f391b458743386506e26321c5828f872f4854373eb3c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e20719789faa84f3842811faee0277ee571a1638590b353a4054ae2e6f0d99"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
