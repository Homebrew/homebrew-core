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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f9d85e731f63b5cfb1a1718d8fdd10c5c4492e7322799270c9def222d6ba268"
    sha256 cellar: :any_skip_relocation, big_sur:       "eab0b936005c6193006e3df8aaf6a53d1ac28ad0d012fca389263ea7efe40e43"
    sha256 cellar: :any_skip_relocation, catalina:      "9172b51aec0372919f8bbaee10ee210643c1134ee5c9640f5e149227bbff7596"
    sha256 cellar: :any_skip_relocation, mojave:        "ed5b509b24e0fffd9a2b543ee0b033f22f2ff9a0c1c6538f27b5ccfe72542ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb624d4ca8307aee1aa6a6197a5f5550d185f0d9d85b32ef9b5f77270988c671"
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
