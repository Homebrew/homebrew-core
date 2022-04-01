class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.4.1.tar.gz"
  sha256 "547c10c2bac792e6273d5131b940ae62f4e9e7c0132eb003be2c43c65fe654d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b999729695acba0b27a7bcd72e2525dca6f9e9a1cb10c4f08871d541d0cc03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85b999729695acba0b27a7bcd72e2525dca6f9e9a1cb10c4f08871d541d0cc03"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a86fcdbc6f72f24eaff7f6c5dc6e8a4fce5c3a8a0a206b994ceee78816f092"
    sha256 cellar: :any_skip_relocation, big_sur:        "60e031931d6fd012dcd6a0eaec185079df332cdbf47d96869ebd2dcd6a9170e4"
    sha256 cellar: :any_skip_relocation, catalina:       "8091d416c23e54e32d4b2e2a9dd98c0c06b05a6efaeebc52d6add1df04d9c4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9a90ca38aa974cbdb9a56e39692fef382dcd466023b92da0a116647f4aa043"
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
