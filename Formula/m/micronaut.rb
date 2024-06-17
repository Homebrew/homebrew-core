class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "74ccb3a4250281009ff5cd827d06d6eabd38122301cd0cb00b37dc5739330495"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3263a01d4cf5922e63601afbf33481607f35f109f53b4d2f5ebf5d8efd336aaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6605b67721274cad4bfa43923db50d401c7a6dfa227eca5954ccf5e93edc41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f5990080a4feccbd063336539b2fcac58c7e586124576e08784f92b4f1a9875"
    sha256 cellar: :any_skip_relocation, sonoma:         "23ab59687afe2f9767339249322d3f85423c644a5f69a317f04ac914ea1bd6a9"
    sha256 cellar: :any_skip_relocation, ventura:        "09abe4b55b734f75b52030306fc694eae3085c0bcec71e7efbc1a67c8f92a3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "66d5c80095ccbdf7cd4004023e619bca79ef1ebbede0924ecdf60d3149d7f4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fffffcac864e3bf8a0676d9b7b44cef0d5989943bad167c56c74ea9b04a9833a"
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
