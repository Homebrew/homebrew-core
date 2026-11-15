class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.6.tar.gz"
  sha256 "1957fe1c35700297f96ff4cf1d1f0992c543784bfa6576b8d559da7bc76fb137"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ceb029892837075d61733b8f4b3e836d52a3f6520104d6a2a82cb8047d51691"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ceb029892837075d61733b8f4b3e836d52a3f6520104d6a2a82cb8047d51691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ceb029892837075d61733b8f4b3e836d52a3f6520104d6a2a82cb8047d51691"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd5a5314df1c84dbdeb9c4f5f8f082ac5fb29b375b6952c3dbca4706335fd65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cd5a5314df1c84dbdeb9c4f5f8f082ac5fb29b375b6952c3dbca4706335fd65b"
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
