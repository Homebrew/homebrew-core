class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.1.1.tar.gz"
  sha256 "8252ceddd4526a4c5d9642f6eb37d35e0d23c91b027fec4887e07374ae73a18a"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f17ec039c40f0b8d0e2c8c05cad5f946342ad2fca667a86b719c7c490c9575a1" => :catalina
    sha256 "25b905f0b4644936f10ca84f094182e14aef234dc5303054847015cf70529b7d" => :mojave
    sha256 "bf6ec5af559b2ba62c5d0d44a16e429a1e3de63a2f7aaeeac587f11fbf3c2b15" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11" # Will be switched to openjdk in https://github.com/Homebrew/homebrew-core/pull/61226

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

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
