class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.0.0.tar.gz"
  sha256 "60725bc2f5acc41cb44a81b6b86d8451492c70043c6b8df6dd7ba3d3fff37376"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfb6024542007b56ab90871dd1a4c7040a146939d3c71430213989a6de313364"
    sha256 cellar: :any_skip_relocation, big_sur:       "3aee5964dc81df9cc1b1fc697ddf9b640f44da2ddf15f0800fb60078d918b8f1"
    sha256 cellar: :any_skip_relocation, catalina:      "54e0cfead37aa6cbe94c1e57c462511d59c4ef1dbf22e4c7e00be4e9f5453877"
    sha256 cellar: :any_skip_relocation, mojave:        "a333cea13aaac477d86b7c97ad52a6a81e05adf2a8f422f6361ed832e355185b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9647e42666e42fd4de62cff316258c090459ea231e085295dcdb0fad5c854291"
  end

  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
