class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.0.3.tar.gz"
  sha256 "fe58ad20d4ac5aa6148c7743ad2a5f4f54741ab54e8b1bb1529bbe573fa3bf83"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e40bb12d07723d65ab871534fd2d00ea6b56b0aa64116f98bcd93c564ae3794b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a08fad966d76eec9787a82f678f67c8c5d743afc0787d62e2f6498da4b7259dc"
    sha256 cellar: :any_skip_relocation, catalina:      "64fc3adb2dc9cbdb103ca0938642a9bc79b56a05d896a8839d82804ffc563ac9"
    sha256 cellar: :any_skip_relocation, mojave:        "186b422e348c0701c68fce652e1374aa00e8da9727b325d1c6c5e738f0f2f174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c5324e916d8f538528784d2eb0abbbd8fb67cfde9dd99224f9e90839a678664"
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
