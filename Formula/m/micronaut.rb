class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "7fc835c1ca939cc240090f6dc37c0e99b1c153ab2875114c3d3107470a89337a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9882969dd4311708140b8141bfa7dd2123c53d7ace0f2c2bc74a67ebfd916b09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ee96a741235fd936908222e340af6c6785bf1cd0148c7d7a168cf85b1bf5c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "328dd1592fe2833642eb6cab70d1b9b06844c8514419b236998d928e1031d1d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd642c6792c79faf85d1495525bccda33abef27328c34243e22f6051d12616fb"
    sha256 cellar: :any_skip_relocation, ventura:        "8002ee45b9b04351dc29ae107f40e43d0039fa1446863ff1b8402fe5f71777da"
    sha256 cellar: :any_skip_relocation, monterey:       "9aade5eed9eb7d1e82d5f46e6dcdf16fc1ca4ebd2846263f913277f07c92be51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc8a16834948a9baaf7ea14696b4bcc33cae36e8bda66f2b2ee371e7282c9e4"
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
