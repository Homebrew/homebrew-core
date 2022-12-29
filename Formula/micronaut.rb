class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.0.tar.gz"
  sha256 "8bee74abd9497086afa2c876cba1a81b66c417910340ad966267cdb2a58a7680"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d44d1df39bdaa982ce4b33bf06fa5c782d719f1348f0cf837147a5a548544c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567c20a324b743ce4e73ae2021ef2802f57d90476df0c608bda7b2b284ef1489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df483f963cd4c03cdfc1d7f0d41b4a53352bd330179ac0a09847cd121c641cf5"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd428093429617cbedf8bab0b84735738ce6eb27087dee33af41a30da5c71ee"
    sha256 cellar: :any_skip_relocation, monterey:       "31bd9dabcb88db62cae132c598633b7a0bce5cf702d08da7519e7df303ff4a98"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab821077efe78f4706b5ec6d8f3272f3c63b63de048dac8297f0fa3044a558b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e99efe7a545c37a359d320780448378d1dd3d7e4ce15358dcf85020cfa30ceba"
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
