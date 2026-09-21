class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.1.5.tar.gz"
  sha256 "d6fd459e43f41bad94188357fc21c84f20b7a2e92d290a203ae77c6f62507d8c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e3ce92e04dab27b6eb0e66f3877008b385f4defd288d0d825aa6441263d7748"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "867582449a237a1d09abd1f97b5da6d1d962d156a21c1d0e32764f154f583d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2220c528e7dac1701a15e1b72ba08739b5563b25938dfcd7369697ea7c37f774"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffc62b0363b9fea735e262771aa57b2a909e8152604b7f09793da3897642f0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "850b295ad3f6947f623da124222d25f60f163a835dfda47967e85666f0a5073f"
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
