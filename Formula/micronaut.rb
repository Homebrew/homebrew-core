class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.4.4.tar.gz"
  sha256 "92be3f5d0e05e810221ef0d123f4e227900487636b9ea31198964bbf3ddd853f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "87cd9ed12a9881f5785a67c7e1fd4ac13150482ea068216ef8382129c2b458b5"
    sha256 cellar: :any_skip_relocation, catalina: "0872031eea2bc8b358c67d9f11fd7602eaa9470718662638ac136d413d0d804b"
    sha256 cellar: :any_skip_relocation, mojave:   "68e3a726808345d3ff6535deb2739f353e0ad0e619fb7a52295f965dd9e6ba31"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

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
