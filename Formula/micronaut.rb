class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.2.6.tar.gz"
  sha256 "82440ccbe1047f0cbe01078c4123723f5a688f5901ac381644010b8fe1f3bf44"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4cc09e646af355e7755e05841f5b9dba8d092345efd36b46843cc388d7b95aae"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ad34e6bd98251cef0c7c3f8192171423cbff58a475e2382dd6f66e517d5bbc8"
    sha256 cellar: :any_skip_relocation, catalina:      "22c52cf574ffeb4ea826a3a0103bf3246b9619f84a291888ed9e4413205e663f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506a2d6e254901a653bddcb140b7ac5b6defbb7e2d9957b1da02a73e9c800737"
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
