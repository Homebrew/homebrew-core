class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.5.8.tar.gz"
  sha256 "219c1281cc93b6cc95692e3391075bb779a0912ac0020d5eeff9b8c157b16c36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2606af973b6285b56dc4391802b67011173e213f1e715106b5471f09f7db3e78"
    sha256 cellar: :any_skip_relocation, big_sur:       "527c4672ad95f7a9648afc51aaef352f2d2f4c8614603c2770d76156f58a867a"
    sha256 cellar: :any_skip_relocation, catalina:      "2198fd9de75e213ba610de94229b609765dfca01f80a45b0d0a2bd347522b8cf"
    sha256 cellar: :any_skip_relocation, mojave:        "a99c9da5ef8e114bbc7ca11fde8f1ab332ab6c9192d6ab660117157dc287a38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88f44362cbb721c18a8b5e11116769f8aef35ea22812759fc7c87dc2e952ff36"
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
