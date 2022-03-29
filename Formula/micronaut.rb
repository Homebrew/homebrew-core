class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.4.0.tar.gz"
  sha256 "1feed38c38e3f0cb66cb392d472c269260fdb8de8418117749c5354b9ba81d56"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c3f3b879503dc293eacabc605eb62c9aa539b3c838ee2efc37f1f6d4616856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73d3dabe952b4779c126c8d68f982059e79235e5327b30dc2987bc0d67a81d13"
    sha256 cellar: :any_skip_relocation, monterey:       "77c6a73151bc21d15211bd20f21d8f2de161d5cdc4e9cb89e1bcca4383f7002f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9fb97f7956be3d21191933aad39bf67dfc9ed8d70d8236a519ae1d68f367cbb"
    sha256 cellar: :any_skip_relocation, catalina:       "f5fece038b7b62dcbf80d1baf709a06b3f8c3993648b629cf763e4e6998e099c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4976e33148f9a2cd608a7f4ada5f0ae21da10e2adcf3f51ca67d55ebd615ecab"
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
