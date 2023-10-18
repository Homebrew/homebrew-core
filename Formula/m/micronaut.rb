class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "286813c385d1998979e72be65e4d891071919f95818d95ad5da1554be7b35b30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3427f0dd74750c794ab7620389bd6a3c5767aef9e20e5cad121253e94d5e64ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2be1761db8761d2e90591e7db58c02612c02666a78b972ad9e2d516df900b1db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3427f0dd74750c794ab7620389bd6a3c5767aef9e20e5cad121253e94d5e64ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fc3821aa3e91b023a2f9a5bd730bdd229b06e4a712841a30d93fa16d1221538"
    sha256 cellar: :any_skip_relocation, ventura:        "2fb7ceceb1ab57a6f1d5e78916b66400470d4c00d5932721af3299495811f288"
    sha256 cellar: :any_skip_relocation, monterey:       "42679af4ff53f7a12b087dea0e331a93882c362466af3dfefa5407d5107ac98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6e07cc1fd25db5778a1d2add525d2dc57b0d085736d96aa4b5c7785dcdcf7c"
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
