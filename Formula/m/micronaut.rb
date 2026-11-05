class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.5.tar.gz"
  sha256 "e2a5979eddb2273704119087a0f8591e7d3deebd4bc03bd8094d52e185195786"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "292154d3d8b110d4c8d582e6ab3c0eb679f70138432bb02294a7e587779ef02a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "292154d3d8b110d4c8d582e6ab3c0eb679f70138432bb02294a7e587779ef02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "292154d3d8b110d4c8d582e6ab3c0eb679f70138432bb02294a7e587779ef02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ced9bb82366fbe43ef0a5c34cbf70e20dc113df04a4b93d777e1130ebc3fefbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ced9bb82366fbe43ef0a5c34cbf70e20dc113df04a4b93d777e1130ebc3fefbb"
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
