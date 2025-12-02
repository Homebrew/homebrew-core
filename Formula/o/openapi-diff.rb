class OpenapiDiff < Formula
  desc "Utility for comparing two OpenAPI specifications"
  homepage "https://github.com/OpenAPITools/openapi-diff"
  url "https://github.com/OpenAPITools/openapi-diff/archive/refs/tags/2.1.6.tar.gz"
  sha256 "7cb3a38a8cdee568ae59cc42752305c7746e32287ee87c8ab749402c35c13376"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99da5d3c09e9ff0eba0d2095e3d96c316b7975f245608ca3f6e89d081f97711d"
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
