class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.5.4.tar.gz"
  sha256 "708cebf8eccf6d1a62c8758f0298dc1d772d2ed791d8608c1171ac198c1898a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf651df42f095f12110ec8112046c0193f23c253cd08ca0a1207178b6faa2b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fd5b162d5c7ffbf184fadd8c9e5ce9e6f8b4f7f60a528a3552c9352784895de"
    sha256 cellar: :any_skip_relocation, monterey:       "1414b97c2f8e5d63c6b103c7d644defab6d60e9b94b95dc87c89c51fcba9c4c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1bdcec82416728205880873198ec6ca4eac513ec224cea5e12c090e921a289e"
    sha256 cellar: :any_skip_relocation, catalina:       "7d9167f125573966c17a96e99560b4fef07002479eb2646ecd2afc6b97c9cd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb83755af9d9f11f727ef1ea688c574ae067c9ef743342b97d2e65c362fefcc2"
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
