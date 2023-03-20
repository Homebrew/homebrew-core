class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.7.tar.gz"
  sha256 "4c2427d419784b5589214d1f8d68e48214b4cd4252e03a6a10e0c70b3fdb5898"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e52d8bd67b06c1fd05740f24c57c94649e55b339d9bac92f7e497fff0153f3d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633496e7c5ea081b894ea78cbd29e943d432825afe07dcd00c1846615aa0bf92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd6ca95cf0581c17e64e2adcd4f9526c71701c471141f64e2374bf6ac084d634"
    sha256 cellar: :any_skip_relocation, ventura:        "f67c5a984dff1ccde8654ec178e729717f941c9fbbb50151eeec9f702ba09d46"
    sha256 cellar: :any_skip_relocation, monterey:       "c70b45ab6d40071d6d8070486616a6b34fc7aa88829ced4852d92c1ec86e36cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c93cc61f33846f716134055d3a2849c98b3b2583482d2eee2090d978e356c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e821918d1bb106a993a9f59cfa615417831eed28c47497e075942289a37044f3"
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
