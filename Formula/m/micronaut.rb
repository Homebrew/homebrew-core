class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v4.0.4.tar.gz"
  sha256 "ce51b424d9f8c9a49f6cbb453942d224a2b25eb4495b2621c2f253ee58384a97"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bb9233a4663b02eb7dfe87b74f86770ebc82f26eaf96bb407438c1e030c8a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d7bd519bbe7d8c246feee5b3c788dd1d410cf08134f6650b39153432b71961"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "525b5e83a9842d016435094e68d436e1ac69e3000b8b6b72a29ee5e7283cc5b7"
    sha256 cellar: :any_skip_relocation, ventura:        "017b4140e217be7fab7ad89b1691216781cb012f91265093d19b9f6bea1500e7"
    sha256 cellar: :any_skip_relocation, monterey:       "04b5cfcd0e85aadc0be09065e5b7da7e021da06e7c84c0feb8b57ba6b68d8cdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1330cfc0b2aa47dbbf35f8efecdc2818770484826a05c14d47a452d62738280b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1840710fa1a8c56557dd77073a79781521182409470787fb22d05d7b09b67689"
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
