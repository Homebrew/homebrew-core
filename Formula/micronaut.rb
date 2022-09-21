class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.7.0.tar.gz"
  sha256 "1c96e1ffb992ab8dd2b287af623b9861653149b8215be2b4e33cebc14219e729"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a17a59dd37264b72ba5dc41de3ea7265350c0a6776d71f7e70556b5858d282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7dbd1be98d5bb5ea0cb29968387f5ac76409f532e42465d39d294bbafb5a410"
    sha256 cellar: :any_skip_relocation, monterey:       "630bb735b4a079418eb5a8a78c881dcf4eae9549deccba3ec623f92f26d25718"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ad968914c681da2d3afecf73f2c397c75d53f991533ed547a0105737da70fd0"
    sha256 cellar: :any_skip_relocation, catalina:       "73cb266e6e12f70a809ecd9016d23c112de99139686d7ba82947e1359f846a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee99af13c775ebbd95e30f7dcfc87857d5978355331ca0810e6c6ce825520d84"
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
