class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.7.tar.gz"
  sha256 "4c2427d419784b5589214d1f8d68e48214b4cd4252e03a6a10e0c70b3fdb5898"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb5304c80e27d7cc95c1fac24b691db65ccead48bfd5333aa3eaddf12ef6d5b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de159219ad34097eb79168a6c1cc5190fc0a2683897f2c320c976d055832008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "874f800429715b0cfa16fa5a9e04f3051158b2fd23f4fa6f70207ba5569863bc"
    sha256 cellar: :any_skip_relocation, ventura:        "efefc87ea95c69c12c5a08b0eb1958e5d542a083e9e15fd4228d59702dac2262"
    sha256 cellar: :any_skip_relocation, monterey:       "93afb6727f0f1b702a0c3e1ae1fb9aea1134b5e52c3f8bc2e19cda3cf952fe52"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe9f2d9c2dd46443a21feda9be9dd4d0b9ef3a8a04bf77b8f80a8d2437596083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b28f1744ec2d6fcc60aef2e85bb614fb0f7b9df96c9038791b90e014c231ac31"
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
