class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/2201.13.1/ballerina-2201.13.1-swan-lake.zip"
  sha256 "a421d07450db11b7b1857f0f914f771c7a4bf4437ef1f9e5765847f9177b26fa"
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
    sha256 cellar: :any_skip_relocation, all: "6148d8b0167eee5173c88d9d33f4418df2ed47a1c99e739aeda6274a7022ba14"
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
