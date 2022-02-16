class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.3.3.tar.gz"
  sha256 "100439cacbeee7100c7f8c33fed7073eb995b8840565474d5d00288c7686e86f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8387cca071a7cc0b6d91d8e57ede7b978f3cc1a0d5784ad3714390cd9b7cd57b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9732b3235a1d2f0eda45291b0fedfee8a957aef571af38aefc277cdf6de9d91c"
    sha256 cellar: :any_skip_relocation, catalina:      "01dcff3a4e13444855b81dda38fa3b1de8c85d4af3b0c71b7a29a51796c625a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edc2e20e34b83f962d9959845623338b918b4c6c6886eb4ad9de0817f8f3365c"
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
