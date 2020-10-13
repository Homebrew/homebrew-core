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
    sha256 "addf570e7c77ad32a21be919cfc16de1b6d0cfedcc53653444d7b36f4f3c606e" => :catalina
    sha256 "bff621b112273752400376c30bf5b6c07e48d7a9c75e1e1de0f2949e3867471f" => :mojave
    sha256 "5e16cca4c6f940351caace915b56b26bde335365ec79148a9f4cf90ccbd046ac" => :high_sierra
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
