class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.4.4.tar.gz"
  sha256 "9ee6b8332b9f6854ca03be4c5bb2d33554fb2dac01c25453ecaccb44900b649b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aacf1c2c28500004708ab22ba0c16ed657d68fd72df6da346dbf242f501e97f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "578a13ad532d764a8697c689cf4fe731ab257209b5bcf3e8a6aa790176e22223"
    sha256 cellar: :any_skip_relocation, monterey:       "346bae11b7566afde46ccb469aad49ba82acdf911e0c66ce87fa199810a247fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "adfa090bfe98a042272e8f2a8144822a04ebbc1fbcc4aa06b1391f880bbcb50e"
    sha256 cellar: :any_skip_relocation, catalina:       "911d014b7404fc790a7cc635d0d070a1d13c4e67a4983b7b934b92ac9f6ff84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9320f292a7a472fb4beddc0185bf3e6e6b3569ac7edc1856ec6e3042f53f7b2"
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
