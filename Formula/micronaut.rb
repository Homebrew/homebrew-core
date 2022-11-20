class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.7.4.tar.gz"
  sha256 "63a4f659106c7f376794b0a86d4922f90d1bebf5059a878d3456f25348f01fed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9626e4187478246040682a4950f1d1d8a2ce728b866fda09e0f343357d5355c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e610e2d2e1f0668570788e9e995ad9f9af2f13e4a03824c0c3db5393c551820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec4540ed37fc96b9464174ee47bed77ebf31b81da3752afe5db746c22c7cb464"
    sha256 cellar: :any_skip_relocation, ventura:        "51bdc6df5dc5046813817757f241ffbaf658de7f90d2bb587f82dcb0d8f0961f"
    sha256 cellar: :any_skip_relocation, monterey:       "ac2105be3247f7b1c7c8751e85c2bc142e6ac6fabbefaca39e4f0e046f277257"
    sha256 cellar: :any_skip_relocation, big_sur:        "5320aaa697d7c6ad0005070cb1c1a934d401fe2cde6281d305abd937c9c25ee2"
    sha256 cellar: :any_skip_relocation, catalina:       "ca30a349898962ee6395ebdb6e18f91c7e814a5f00aead8657f9f99ba595d878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22c3b78699d96c2c3629f6196a5bf66047b5c44547f7422ee2c7b395d625989"
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
