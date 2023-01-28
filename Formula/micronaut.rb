class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.3.tar.gz"
  sha256 "343712d2752e7a56d603dae7ed6490712a3ad902316dade7b95c6f30da1c7811"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "859c364da6e57f663965e577bdd2e1df85e71d284c8e608d9f4e1ebdfdfb1aa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eb6cda3e39bba10de780374e4982fedeb6d4d06ac94a042c24e3940bd40d932"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25540d7690cb98f0ad58531456c60b4eb7bdda713573a30892ee84a88e581cb9"
    sha256 cellar: :any_skip_relocation, ventura:        "66a2ac1d4d89eec5d2c21a8a820b310ae38338d79bd7546e00acf06460c5fbc4"
    sha256 cellar: :any_skip_relocation, monterey:       "87a25f685f5a25474848f6a12c7e34c82a17c7cc2f9c7c38539dc4d56306ad95"
    sha256 cellar: :any_skip_relocation, big_sur:        "d49dded53cc1820e01bd5e48344c69c88668b409d931a430a08982dce10c8ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cee561f3d9b3f7650e2585ee805aff000373ff36bc28b4669cff142fe2fe555"
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
