class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.2.5.tar.gz"
  sha256 "d796d1c23387bd2abafeb7199263b123c39462a7b581a3684e3d11509bb5d0ba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f03c11bde30dccc06bdf912906e0a94314e25181654100f3572e0cda2a9c990f"
    sha256 cellar: :any_skip_relocation, big_sur:       "34e74fb04cca3f20379dd4b87bd8ff1cabecb8b3d5d9ee6eca1404248df64b84"
    sha256 cellar: :any_skip_relocation, catalina:      "eae9f7cdbff5d63d32c94f1fd194024b8c882f833d32019fec98ea0866c45cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e34c2c5c566240f3dc36e844632e2c71f21bc4e5ddd735bfe4cf99dec8ba4fa"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@11"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("11")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
