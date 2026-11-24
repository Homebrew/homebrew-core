class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.8.tar.gz"
  sha256 "519a947db32b6df4fd1679dee7c1a394a62c2552d1814a9bfb21078884e056b9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "0d4ce3e9bd33caafe6aee19046f13b3d0a38580ceefdd70bf939d5650dcacc6d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8220cfe9d66176902c4bedd4fb435997d8b9206439cdc7cbddf57320916bd94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8220cfe9d66176902c4bedd4fb435997d8b9206439cdc7cbddf57320916bd94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8220cfe9d66176902c4bedd4fb435997d8b9206439cdc7cbddf57320916bd94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82378e55a9d3ca7a482c8e93be9103952616830bd2a78078ee338ed7b1802716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "82378e55a9d3ca7a482c8e93be9103952616830bd2a78078ee338ed7b1802716"
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
