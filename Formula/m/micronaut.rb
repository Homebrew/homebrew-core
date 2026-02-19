class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.8.tar.gz"
  sha256 "a58994f10b85119b681d514586a6bcda49f52722d484527f4b95473b27c2aeac"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6e992e751be8623eb4523d05e144d7a353889719663d968cf1af58a67fe25a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b7bef2b294df46d492f42b5a31b8f9c8c9f6f1b59645b0b3a75d414e637a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f4e62f43b8eae5b52dca29bf5f7d70105eaffadc1b7d521a718f95ce1ecfbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fee0af8bc49abaea2258fe3b56cb31c00feb2d0283d42333ebbe9ac26f7aba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d208f4515fa6234b1138c42b3d75924d37f6b56bccdcfc78760e617764080e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18446d65be7365ee5bdc3ef325c3dc7dc4d8969ac60e5c18ac230b006b175a7a"
  end

  # Issue ref: https://github.com/micronaut-projects/micronaut-starter/issues/2848
  depends_on "gradle@8" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
