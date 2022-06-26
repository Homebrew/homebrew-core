class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.5.2.tar.gz"
  sha256 "e424a51b84cbdaf9f41238204a4604beffc8ec97a02b87bc121aa4c846596812"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4caf45170745a204332774dfb55f1bdc8da1ad3603b1d6d96dbe39a6da3243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5125884d35c242642c1473ce73309222efa2be42c343cbe4451c8e1970b7ed30"
    sha256 cellar: :any_skip_relocation, monterey:       "ca7a4d1f7b645c586ca51d75bd8ad342ca9c45381149d5a7775938b9c3007fdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4df21c601a665c22ecf4c893f70c547e07b36132c002d59b7583ca7e96ff0819"
    sha256 cellar: :any_skip_relocation, catalina:       "7521e1cb167ce99b45124962f3b279535b09a2a60481309a6c5580b397bb4193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b58dba2905cb18772a94111ea78340f6e37ada1b8ac136b5b086a910414333"
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
