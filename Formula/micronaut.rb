class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.0.1.tar.gz"
  sha256 "61b58f5fd46c2986929aba75add112e20fe69d80b1425f6eb4389edead36887f"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "04070f1c0d03d4929534bd0ed36447fc50c3fcc9ec2fe95eb88ecceb211379b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "493d84f3de354af6511804928d2105aa0d777f842795dca0332ec91a50ac74ea"
    sha256 cellar: :any_skip_relocation, catalina:      "eb811d45baba54fb60f6a3987de1ae72ad22ec14b0f6f4e3b5fa23a03b304b02"
    sha256 cellar: :any_skip_relocation, mojave:        "d671f193cc23d3e5b72d746a954d8603ea5db224e321d1f33248eff2195fbe45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f3b70dd1c66c1c1dffb6ded9da09276f094e280c280d44e887f131ebd4e7a1"
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
