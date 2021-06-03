class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.5.5.tar.gz"
  sha256 "d40fadba548df087c57919ac8ad685624ad39e3add2fad8e52d2af1912c68815"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "89fe0c6a1fb8efab3b6677fc7a180b48ca2825a413ca08f11695c3db6210dcc9"
    sha256 cellar: :any_skip_relocation, catalina: "5c15ef34d1103d61a5e57c418d464d979143f555952030672243e71be2600c8c"
    sha256 cellar: :any_skip_relocation, mojave:   "1e9a7d6099788f287af39b5e77edd75ab5313e161ff43d7c8bcae65d3bac8a54"
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
