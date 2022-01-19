class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.2.7.tar.gz"
  sha256 "92046a84157254989d66bf29adf217ba434b7bc1d0a35229bcb018ae865530bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40d813cbaceaca4a7299c379a3da7642c853fea0df6a6df9f78f5df0e20719a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c9728ed95c4176801161256320e938299a070a8ef73d37fcdab40e3a0c34c7c"
    sha256 cellar: :any_skip_relocation, catalina:      "cc39c1517d778081b93fa0078419ba87bba8ae8471194ee927799c2b8a101f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fede89148207fd15cf55c7d783bd0204643ee4b81a36a0523733965756fe60"
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
