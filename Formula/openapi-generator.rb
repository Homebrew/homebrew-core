class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech/"
  url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/4.1.3/openapi-generator-cli-4.1.3.jar"
  sha256 "234cbbc5ec9b56e4b585199ec387b5ad3aefb3eda9424c30d35c849dd5950d2f"

  head do
    url "https://github.com/OpenAPITools/openapi-generator.git"

    depends_on "maven" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
      bin.write_jar_script libexec/"openapi-generator-cli.jar", "openapi-generator", "$JAVA_OPTS"
    else
      libexec.install "openapi-generator-cli-#{version}.jar"
      bin.write_jar_script libexec/"openapi-generator-cli-#{version}.jar", "openapi-generator", "$JAVA_OPTS"
    end
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
