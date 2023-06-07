class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.9.3.tar.gz"
  sha256 "074c6cc6375662766f3b705b92c63407e88bce4d0126e2bb4e01dc12b7a8ec2e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "881c596ca3a142f2a87e2eade9f7040d9fac49f94853c53e564314f059d3c0ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3865047bf65160ca1448402bd6a765257d6ad8bd7714f255fe34fa0bcf82db4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6c0c7a6096145aee5e864919d881996d7531c7fd3615c56f188ed9deb03f236"
    sha256 cellar: :any_skip_relocation, ventura:        "d8e89a815f9ffc3757013dc86cbb126535b9e3a94a1f1abd54a4944210448b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "8320e027886df06cd6e9bd17e7490dd866b505bd94a08e7f1cca988d69e27b74"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d543d7893a9bdb9f314a2e978dd45f4e2591f7f4ab8ae2f101d969c06a003dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7758c3663e9979284eef46fa8b9cf6e513d1ba0c75068fac5e18f10cc89c96"
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
