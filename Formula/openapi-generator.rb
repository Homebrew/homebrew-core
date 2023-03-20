class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech/"
  url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/6.4.0/openapi-generator-cli-6.4.0.jar"
  sha256 "35aead300e0c9469fbd9d30cf46f4153897dcb282912091ca4ec9212dce9d151"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e002f4cd58f4bea0c04bcd3303bca97095309828541363a2113bcd859200bfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e002f4cd58f4bea0c04bcd3303bca97095309828541363a2113bcd859200bfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e002f4cd58f4bea0c04bcd3303bca97095309828541363a2113bcd859200bfe"
    sha256 cellar: :any_skip_relocation, ventura:        "3e002f4cd58f4bea0c04bcd3303bca97095309828541363a2113bcd859200bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "3e002f4cd58f4bea0c04bcd3303bca97095309828541363a2113bcd859200bfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e002f4cd58f4bea0c04bcd3303bca97095309828541363a2113bcd859200bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df6e5c27f99aa2d6123880a0795da5bd27665dd9e04c37a9fcfb02a66513d25"
  end

  head do
    url "https://github.com/OpenAPITools/openapi-generator.git", branch: "master"

    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
    else
      libexec.install "openapi-generator-cli-#{version}.jar" => "openapi-generator-cli.jar"
    end

    (bin/"openapi-generator").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" $JAVA_OPTS -jar "#{libexec}/openapi-generator-cli.jar" "$@"
    EOS
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      host: localhost
      basePath: /v2
      schemes:
        - http
      paths:
        /:
          get:
            operationId: test_operation
            responses:
              200:
                description: OK
    EOS
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "./"
  end
end
