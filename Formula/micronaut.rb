class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.2.tar.gz"
  sha256 "121acea22219acd3371182c5bf8b67d43c2b6a093f06446fb3406203008aefe1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e34dd3a228d2d2b506b4575be0972e6c37e7255d92bae8289f524cc27e03009"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28831d18db13946ba8f0f481f5e464dd74639ee913635e68ec20b9bb2bf691d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5270719895c85da460c8716713e8940c03cb607971d8396bc30c2400f8d02150"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7b3107b0268373d230187f2e4250c7a8cb42a7a4ca90201c3c9b137aa7313c"
    sha256 cellar: :any_skip_relocation, monterey:       "001a2a14b3cbe303676f4b387775a13a59a221a693dcc82f30df260afa27dbeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "21d5db0a531646dbaea96de43ed32c05510ec30a953d5e801fb10985711f28b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62eb2e86b5fd9a6b4562b2063cbc0a868ad5db64107ed97e07dea40224e90e5"
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
