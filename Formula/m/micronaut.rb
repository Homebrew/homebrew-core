class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.7.tar.gz"
  sha256 "d46501746f606900641cec0562a3cd675b280e6a1b5e7f59964b54b491577cc4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cfe50064fc080cfbf1a72fc22075f7b92e27bccbbaf9b56715d569cdf33fb01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3cfe50064fc080cfbf1a72fc22075f7b92e27bccbbaf9b56715d569cdf33fb01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cfe50064fc080cfbf1a72fc22075f7b92e27bccbbaf9b56715d569cdf33fb01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29577f8d9e8aa00467e14091d32e5e0391c05fcf66f782ade01ba2d1fc688c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "29577f8d9e8aa00467e14091d32e5e0391c05fcf66f782ade01ba2d1fc688c17"
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
