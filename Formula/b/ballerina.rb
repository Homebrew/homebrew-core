class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/2201.7.1/ballerina-2201.7.1-swan-lake.zip"
  sha256 "b3665a64cdf08899ee206d10e813a0efcb8541b3566bf3101e67e3933e70d34c"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/ballerina-platform/ballerina-lang.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4614c91c3da8e858e4911b2d0cc9b1a53392b1aa305a34fbe64f9ad416cd5abe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4614c91c3da8e858e4911b2d0cc9b1a53392b1aa305a34fbe64f9ad416cd5abe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4614c91c3da8e858e4911b2d0cc9b1a53392b1aa305a34fbe64f9ad416cd5abe"
    sha256 cellar: :any_skip_relocation, ventura:        "4614c91c3da8e858e4911b2d0cc9b1a53392b1aa305a34fbe64f9ad416cd5abe"
    sha256 cellar: :any_skip_relocation, monterey:       "4614c91c3da8e858e4911b2d0cc9b1a53392b1aa305a34fbe64f9ad416cd5abe"
    sha256 cellar: :any_skip_relocation, big_sur:        "4614c91c3da8e858e4911b2d0cc9b1a53392b1aa305a34fbe64f9ad416cd5abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f51f77037910b9c781c3e41e0243db762af75e571628358b3ac1e2c5ccf7fe1"
  end

  depends_on "openjdk@11"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/bal"

    bin.install "bin/bal"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/bal run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
