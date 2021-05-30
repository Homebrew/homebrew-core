class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.4.4.tar.gz"
  sha256 "92be3f5d0e05e810221ef0d123f4e227900487636b9ea31198964bbf3ddd853f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "982a3f6b57c3e004b3f05cda7e7d4e0b7d3e5eb125fca1f44bf7680e00b769e3"
    sha256 cellar: :any_skip_relocation, catalina: "431895ccdfba318540d52ebc1a4c464adaffc1a96911458cdd3e33c28376eec4"
    sha256 cellar: :any_skip_relocation, mojave:   "cd97a51d7513f3df24a9ac6d9486a84273c4e22c70173b4a0fe8a0ad6f722b4a"
  end

  depends_on "gradle" => :build
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
