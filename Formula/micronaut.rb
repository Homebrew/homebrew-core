class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.2.0.tar.gz"
  sha256 "40680a055eb457a5d1e2f440a057aaa8f6d619c5e75424850c936f0ae9fb75b8"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7472723d14dbee0d198e1487536edee85974295ffa11040b8c42b2b67795e571" => :big_sur
    sha256 "25b41c0be45da56cb80d9c5d78389f3f147bdd3c6ab7c16d4931b2bc1bf24b21" => :catalina
    sha256 "e601f7c6397ae2962ca60d085184838a26d0ad9bde984544dbae8037460ece14" => :mojave
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

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
