class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.5.tar.gz"
  sha256 "87ef849dff357d003c547fdf084c063ca62602e69d863959622bb41be8006125"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1125dce8328bef340905039be03d61986acd52dbb944d46cb33576a145d3d613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69683a4716ba31b81d3beb47bf413e9d39e434e23a899268285449005da0236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a11aa967caf5ed2050410762e7532c4af8e35b2daa4479ca07a67fcb211a753c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f65a4a0376b6fd53e77d29806cdf5af532c8f60d3e3b770c996fd40090b224e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5459a84dcef351ca5b792b9d93ef00f34e42803d3174a35c501bb0e12f64aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4ad386b3373ac4a911fb483f9698817b9c871075acc90eae7d04af8a3ac819"
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
