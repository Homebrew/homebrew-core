class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.3.4.tar.gz"
  sha256 "3984ab5cb676ca853b68aa8a6eaf3004038061187609ee7b122f7eb812ad8b9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "124df47f44bb58cc09a274e32f242fb1c01096b69f6adeafdd02b871c5e8c69b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2635a6623d4d3372e8934313371029c4bf634092fefee7436e3840cb5bd708b"
    sha256 cellar: :any_skip_relocation, catalina:      "aeee41d72341852a6832c7e3b20af5907920c70291958a32cbd6a216f91a655a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ac230f68f5ebc3d28f814a5a7fb7575ae3d2faf513dea279db73c647d8a8c6"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk"

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
