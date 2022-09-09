class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.6.3.tar.gz"
  sha256 "69eac483e65524fb863e67816b3758c300d1c4bfdab01c6ea5f91144209d7d7c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0672d888fc8ce947d995a457ff439fa5a9f5d0882f73eca79502bfac91c4153"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d72dc59c628b8129dec6cd1237260d2ad8ca0d1b5a660ff2eb7c69f1a05a8257"
    sha256 cellar: :any_skip_relocation, monterey:       "efe45e7119b0daf6a17b0b732d6a224b8d70d3f32d3026e1abdffe85373518a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "341c32c1c97a2803524b32a9fec0a6223b64cb1b6b5dfc236e131cf2e8434a04"
    sha256 cellar: :any_skip_relocation, catalina:       "408d5db309a592f86c81443e498cfc65c2385e97066a6429f60835bc43a9eeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d65ffa033cee5c7513686d2a073b927d733679f119dfac771f79f605ac505ad"
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
