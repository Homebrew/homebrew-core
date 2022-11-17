class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.7.4.tar.gz"
  sha256 "63a4f659106c7f376794b0a86d4922f90d1bebf5059a878d3456f25348f01fed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "853f12f7b92b5490da59616c11ff3038a307c55498bf80dbd75cf9bc1b624825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9890c60de747277735b7fc8944031f2f54ecd6dc23e8d238e065b0256e53a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7877aa077b061478919e68125249ff29a37771423229fe8c333a002d13fbb3a5"
    sha256 cellar: :any_skip_relocation, monterey:       "fbde03d6f09f186606a0ed628455cc3ad4ca70b2eac912fb0d896fb48f76a93e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d59cadbf9a1e221296dc567bc9f5b58ff01cedbddbdf8f4038ad667f1220d63"
    sha256 cellar: :any_skip_relocation, catalina:       "397b8bb2ff59e17ddbf68b3fd1646221af22afe74efa83dcd49b927e15b00c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb31a456aba48604da496947e69b19864199feff7d2b9d2b8fffb95461b3395"
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
