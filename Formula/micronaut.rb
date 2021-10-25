class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.1.1.tar.gz"
  sha256 "b74c604d4cb23953e4c600bed933ad546c50015302bcbddef6638930473758d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "066e6d6eaf99070ff22d278d649db2e4bd7568e65e0f61dfc9ba12591626b086"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a035be33a6a864a6f4ef8d06e62435b52c1968537f56aff9489f0bfd30d08ce"
    sha256 cellar: :any_skip_relocation, catalina:      "c49b17c932385f0cc93d05176d37912cd74f1fcf16318047b1f8caa36a03a3e9"
    sha256 cellar: :any_skip_relocation, mojave:        "0e772ebdec5f685f80dcb8dd47419f099d322a379f2fc8bd389c4ae1155bc6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6aee4b194e4547e8ef8d39d6488005b5d432a66007fd0bb94dc2b91b07881a1"
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
