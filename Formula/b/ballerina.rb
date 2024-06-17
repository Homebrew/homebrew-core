class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/2201.9.1/ballerina-2201.9.1-swan-lake.zip"
  sha256 "73c46a8e4d9c8ee89bb931f48459abddd23eae9c2b5d9d99caf707070aa21308"
  license "Apache-2.0"

  # The Downloads and Installation Options pages don't include any version
  # information or download links in the HTML. This information is instead
  # found in page-specific JavaScript files but those use a unique cache-busting
  # hash in the file name. In this scenario, we would have to fetch the page,
  # find the JS file name in the HTML, and fetch the JS file to identify the
  # version. To avoid that setup, we identify the version information from the
  # release notes URL on the Downloads page (though it's a less ideal check).
  livecheck do
    url "https://ballerina.io/downloads/"
    regex(%r{href=.*?release-notes/[^/]*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06e52a3f2cd00780a562e4522f7cac42c940550572ea7b538441750d21488c3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06e52a3f2cd00780a562e4522f7cac42c940550572ea7b538441750d21488c3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e52a3f2cd00780a562e4522f7cac42c940550572ea7b538441750d21488c3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "06e52a3f2cd00780a562e4522f7cac42c940550572ea7b538441750d21488c3f"
    sha256 cellar: :any_skip_relocation, ventura:        "06e52a3f2cd00780a562e4522f7cac42c940550572ea7b538441750d21488c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "06e52a3f2cd00780a562e4522f7cac42c940550572ea7b538441750d21488c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f53893bdcfb47b87245ff304c9eb7091c9a01347ba16e2dc8f5d85db5ae9062"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/bal"

    bin.install "bin/bal"
    libexec.install Dir["*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
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
