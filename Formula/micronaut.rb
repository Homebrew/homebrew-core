class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.3.0.tar.gz"
  sha256 "d3a8ef78beb90880a56d2b00a480cf0d86fb14d7957b430395eaedf75ed59c51"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e699117cc0cc1be3dd173e893bc003fc0a1219ba574f8548acd49913c6ef0f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "692b4691e0bafe0a63134468e0d47b9391ef2664853524b3a8d2e537bcbeb7ea"
    sha256 cellar: :any_skip_relocation, catalina:      "7504c3bc9681814b72c944524962042d3aa56e4c7fb47c1267d639153d19e1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f022121521bac69c6f38c6c70f5779a60d1c32d81be495ae36bf358ff509bbc0"
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
