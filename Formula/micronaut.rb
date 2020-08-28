class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.0.1.tar.gz"
  sha256 "584c5abae644aed6cc86e932f5f6aacb86becb93402d71d578bfb2d9d4bd41c2"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0af1ce0fe51da38205f6ae4c0dc2bdaaff0ab5d0ba20efb3e584b81cf44d92f2" => :catalina
    sha256 "38f0df54c92727eb27ef61025bb4c95cf1de45e9368595ade7e53a6771833ad1" => :mojave
    sha256 "d8beed32a8279539c9bebac12c5c81a46462ce9895e85241a02a5a940802647f" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

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
