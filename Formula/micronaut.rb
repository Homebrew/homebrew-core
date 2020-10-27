class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.1.2.tar.gz"
  sha256 "a124ff3b6b7bccad95d1322452c5770bcfdc484b866dd95100e9cf9648807ccf"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "20f614ab1f26c0d1678fc35e070b982ad1ae87f7428e919073bc27471398be85" => :catalina
    sha256 "2813a542b0901b90ce8e80efd655d5932d26954448794b22119ab1b92677fe3a" => :mojave
    sha256 "b9516aa1f963eab49a19a8feb7e1c93e3ac4645520fac0cb0993c183b751a73c" => :high_sierra
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
