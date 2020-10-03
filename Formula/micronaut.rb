class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.1.0.tar.gz"
  sha256 "4ecb873b8bba327a33c9d9bd75d86ad6a8a44dbf1573ef6cd5b9a658b3799c35"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cc7b187a08622b2233f9ee97e01a25ac6460d602fbae53dff40750f6ef042a3c" => :catalina
    sha256 "a99e579f3ee1ab88058512251a3ca973a742088c64ec6060b37f406592cf9a37" => :mojave
    sha256 "22e96a3a499fd30cc1e5c988ce03634209225fea7a117a086a0f222be079dd6f" => :high_sierra
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
