class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.0.1.tar.gz"
  sha256 "61b58f5fd46c2986929aba75add112e20fe69d80b1425f6eb4389edead36887f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d092d5a043d479d0a3293fc288fe47d2e6ea65b02a70634d4248237f66a8bba"
    sha256 cellar: :any_skip_relocation, big_sur:       "d20fb9a3fde239aa7315e26b6ef4a7d2686befa344ae7d6c96a196333755a63b"
    sha256 cellar: :any_skip_relocation, catalina:      "a8e3ac5e16648912e90bd4070ec564142cee7aa42469a9ddd1ad9ed5e8ce8519"
    sha256 cellar: :any_skip_relocation, mojave:        "117baf5eb6c8ca4dacab7367bbe58b5a541932d74a9d2b470a3431fbbaa3c11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e377997493326e7fd19de0e8d9b27da947ce74fc5ca98cba6d8489e107259672"
  end

  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

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
