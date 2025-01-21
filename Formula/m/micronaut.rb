class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.7.4.tar.gz"
  sha256 "fab0f1f440d5640c24f7fe19235d037754fe325ded6e0759b91b1ed0dde91cbc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4539fe4c8ba7ffddaf5efc1988899267e63ff1b09525f9a9beeb33ca89844d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b4d63f6a5d0686f1a55384158396f30a2d9b46173acf64a2081d59833c6f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5e5253b0bdc22c37a1e143dc21e41023ff7e778b0e71cd5f83aac5105d37988"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c607650696b6bf69170c7356bd45d57ee4284cd75e0a80d5035a7cd2c313ce"
    sha256 cellar: :any_skip_relocation, ventura:       "26fb315aeb101924fb230c62ef9e792ce5dcdf08c7f4cd07c1e02218f8eb1791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddeae964ae10b06847b643262dd9b9b9e21967febcdf485006139a571bc27013"
  end

  depends_on "gradle" => :build
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
