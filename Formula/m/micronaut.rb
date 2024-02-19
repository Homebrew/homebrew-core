class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "a86871eb28a5f885f4294395ff8da437f2ba6b08805d2e72d2ca61e70f38d162"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7efd12fdd0c58b07ed83c6bc4895c0584b9a6c812dc80deadb289d7efaa4a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc783be709cef1ad3cd32ada7fafc8ce96246999798fdec38056a749bcbb5d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc94650771597b587fd747a3be9ad268c0ec897da30c17f3f75447b511d421f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b7ebc76d21dfd002900ba7ea1ca62d7b54442f634525a7a129dc7ab65af508f"
    sha256 cellar: :any_skip_relocation, ventura:        "3193c7840b98265d6af9f8062cbb74a58bb5df3fbc4fddfcc239370af2c22b71"
    sha256 cellar: :any_skip_relocation, monterey:       "6b16b79840e12b9325ab3e56e7bc2d76588879c207ee9bfc5fce6af2f3ab1352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "448807d05f0ad055cdfa4750909be3a01f896d65b71ceedbbfb26e07fc5df9ae"
  end

  depends_on "gradle" => :build
  # jdk21 support issue, https://github.com/micronaut-projects/micronaut-core/issues/10046
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
