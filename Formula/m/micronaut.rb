class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.13.tar.gz"
  sha256 "3b58edbfcf7f885c07d1b89c1091d8b64bfca10926a70792fabbf02628a16e28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88f5ac7324abfa268a492458d5581e7e70db524c1cf6faf582bd73f1864e494b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "152ab68516afb23b87318e97f2de4856fd4a74cebca806dac37a2e15c6828d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e8529f6cf55e11a346a6c961a4389aa0cbbc002df442f68a0f291d496d784d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0959afffe91e92d9c763167c140c6607d3b8ae8bfe58376a5f76e75ec24c3f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8db09b51e9914e8a11e673e4f4b41934a30e729af6cf68067f8624bc83bcd8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992990279c7a7d79d8032e9805901c76e61903c0f2c84d57aae7461ddea9c358"
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
