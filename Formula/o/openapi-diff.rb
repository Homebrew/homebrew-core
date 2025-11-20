class OpenapiDiff < Formula
  desc "Utility for comparing two OpenAPI specifications"
  homepage "https://github.com/OpenAPITools/openapi-diff"
  url "https://github.com/OpenAPITools/openapi-diff/archive/refs/tags/2.1.5.tar.gz"
  sha256 "52c036780d668c2034567b4f29c798f31cd907929b4bd2c2a79a93b1e7bc4e0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cbcf13308e32b39a3e4bdcb92c9b054c2d0e3573289cf161586d08dd2e4b26b"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "mvn", "clean", "install", "-DskipTests"
    libexec.install "cli/target/openapi-diff-cli-#{version}-all.jar" => "openapi-diff-cli-all.jar"
    bin.write_jar_script libexec/"openapi-diff-cli-all.jar", "openapi-diff"
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    output = shell_output("#{bin}/openapi-diff openapi-test1.yaml openapi-test5.yaml")
    assert_includes output, "API CHANGE LOG"
    assert_includes output, "API changes broke backward compatibility"
  end
end
