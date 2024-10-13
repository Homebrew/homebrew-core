class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.6.3.tar.gz"
  sha256 "8a7bf4e435bf2f6637155e9707c0e6e781802788f4a905e31ff2300ef0bb0334"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "213f2be1f310682a38194eff1957de5a53a8913e2933ff5cb8087cb6694b2947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748205e93688bddc5788b62f29627cc3a55627d392aaea5920c1acf7c4c7099e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e12cf8e57b85d77f7ec52c9dd8ac7aec53b84079b5cd201fe5254f0d88d3ad8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9550fe1241b29ff0d452202354afa861a3c07dffcd7baf248ec22cc37df293e"
    sha256 cellar: :any_skip_relocation, ventura:       "94950a29594ff42730e38e75fbdf1426db8d128535a3fdf4e9ac21c32ad30fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d87f81c9427341de3f03a93eb948a5cc4448ccb505840184721c8b025661d7"
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
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
