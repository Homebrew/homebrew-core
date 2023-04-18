class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.9.0.tar.gz"
  sha256 "45b7abd3fa311cd4f3a52d358acd460e06a8c60eb7eb1b3747d9160df21003ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0999713def2c9d44b54b8595d5c9c23d592897bb2a12b1a976eeaa9deabafcbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229938832b9f10352c04e4c1cbaf38a8a0c3884e5b2759dd140b423bedda0bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a93ffaa4fb24fdd8cac5b99c4a0a5f002b47767f26b31fa3cd553c03a7406347"
    sha256 cellar: :any_skip_relocation, ventura:        "5e4380ef1ef334766e60c294338dba6472906a5aaaeaa87e1dadc4bf83877652"
    sha256 cellar: :any_skip_relocation, monterey:       "148a58a9ab053dc8a1576ee0bb9c69f9f7b5d707a62a48888bece7eaf961b22f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bd02165800e9448ce597c2c086cf645abd6fcda9e71c987ddb1a6e3d3a393ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3cb076f88aca81eb2d17c7820ebed1de257364dc8163da90c731e4dccc4ca16"
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
