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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "864d38d8ef1fa74ca9b3d5dfa02b50963e9854eb7516e907969d193c3b462011"
    sha256 cellar: :any_skip_relocation, big_sur:       "702615d85f05601c0b7f70e8947016c56a223f9d6852d73f6e00d53fd42844d1"
    sha256 cellar: :any_skip_relocation, catalina:      "dc5864d8456f636f956d3b4cad2e12bf4f873793a66c4eba4505e4a1662da19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86e69c580736b5120e582b08281b1dbdf20e8895b55166748081879ec9309d1"
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
