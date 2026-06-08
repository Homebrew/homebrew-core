class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "e6815d58c00e5da7c7bbb3d984be124cbc2413b78017175d2ce3fbd26d1d9cd5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd99e27e33ccfc5416f59741dd789e45326bdba3426b8994712447e410a0db1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bde8c7b9302b46127a21d52ed1b8306a70856c5e48f584ca91aaa85d0192c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fc80f9be699271a2b398781cc63193f2ab9bad093df579ee9cbf9cc795373c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21bb976303641da1eeff64136250b5eb4516a58f5afe29cb4620f58c455ed9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fce21de872fca74290d78a10ff91aa8ae23153bbb25df171a13f5b716091a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487531f1d04372a47ab68692ef3ef6d9ec2f848b7b192fc78e7ce7942c12e680"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
