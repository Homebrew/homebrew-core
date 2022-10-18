class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.7.2.tar.gz"
  sha256 "331211d63603c8a5fa00ac7629652938a9fbbbb6da1a68f6b2c1697b756e6968"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96809316593006721f65c1f0a021ce0aaf1afe8cf6dc4b6feb766de2b2d2e5a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0ba62628a64c9f6fa31cfc0c4cf7b6ef205efe133e73b71635e06048aeea8e4"
    sha256 cellar: :any_skip_relocation, monterey:       "cb29c481ac7cbf3aa6ad8d6340fd60999523105e767f783d94240c2486bee930"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f6059d10a70d8a830940e6f79d9c0cd4bdad84d3fc6eaf5fef1fe21868dd38"
    sha256 cellar: :any_skip_relocation, catalina:       "a07f1fcc2658189195e46f4d545421cf32a7cd291f8a81efb9710c710610406f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0161b29ca9df0f4b131d958a491b39a78189ebf4af70d167a0ea96dcb3a71b9"
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
