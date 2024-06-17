class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech/"
  url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/7.6.0/openapi-generator-cli-7.6.0.jar"
  sha256 "35074bdd3cdfc46be9a902e11a54a3faa3cae1e34eb66cbd959d1c8070bbd7d7"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64e3c10ecad4e2e31fccdfd1487ba4c5533aaf8f8794fae229f1953c9f127903"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7de4dcb975333718c39b7d58029d3c563bc2ddd34da372eec2da83545321cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc560c3782333fa5f5c701f835e107700f76d8075e6c75163aa0b60e8cb85f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e75ef037f0a63c7bdf1beb90006257bbc6027b139639817c0571aecaf10e8a3"
    sha256 cellar: :any_skip_relocation, ventura:        "74e389ee43933bea7a4684026bb34006bf07752e2838bef1d01995b5b63ea608"
    sha256 cellar: :any_skip_relocation, monterey:       "48dbbe3d085781e5fbca210ff2f39ecfeac6225a3c1b8e2372b5cc7fa3a552e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c109b6f6d3813e733c4faf58d31f2cebc98c57ed30ded13334fd36bb07e30578"
  end

  head do
    url "https://github.com/OpenAPITools/openapi-generator.git", branch: "master"

    depends_on "maven" => :build
  end

  depends_on "openjdk@11"

  def install
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
    else
      libexec.install "openapi-generator-cli-#{version}.jar" => "openapi-generator-cli.jar"
    end

    bin.write_jar_script libexec/"openapi-generator-cli.jar", "openapi-generator", java_version: "11"
  end

  test do
    # From the OpenAPI Spec website
    # https://web.archive.org/web/20230505222426/https://swagger.io/docs/specification/basic-structure/
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.3
      info:
        version: 0.0.0
        title: Sample API
      servers:
        - url: http://api.example.com/v1
          description: Optional server description, e.g. Main (production) server
        - url: http://staging-api.example.com
          description: Optional server description, e.g. Internal staging server for testing
      paths:
        /users:
          get:
            summary: Returns a list of users.
            responses:
              '200':
                description: A JSON array of user names
                content:
                  application/json:
                    schema:
                      type: array
                      items:
                        type: string
    EOS
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "./"
    # Python is broken for (at least) Java 20
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "python", "-o", "./"
  end
end
