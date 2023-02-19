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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d60726334f03d6ab64cb8086c383d72a320e3dc6bffde86a1d9cabadd1420a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d60726334f03d6ab64cb8086c383d72a320e3dc6bffde86a1d9cabadd1420a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d60726334f03d6ab64cb8086c383d72a320e3dc6bffde86a1d9cabadd1420a7"
    sha256 cellar: :any_skip_relocation, ventura:        "6d60726334f03d6ab64cb8086c383d72a320e3dc6bffde86a1d9cabadd1420a7"
    sha256 cellar: :any_skip_relocation, monterey:       "6d60726334f03d6ab64cb8086c383d72a320e3dc6bffde86a1d9cabadd1420a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d60726334f03d6ab64cb8086c383d72a320e3dc6bffde86a1d9cabadd1420a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e76029092fa9349e487e1db47da0c334f74a8a9be77804e42dad764d594e14d"
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
