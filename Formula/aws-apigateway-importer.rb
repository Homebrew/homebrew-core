class AwsApigatewayImporter < Formula
  desc "Create or update Amazon API Gateway APIs from a Swagger or RAML API"
  homepage "https://github.com/amazon-archives/aws-apigateway-importer"
  url "https://github.com/amazon-archives/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "8371e3fb1b6333cd50a76fdcdc1280ee8e489aec4bf9a1869325f9b8ebb73b54"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "3a837a89af7bfd9454b2e12924323e82ab6cb6ab09f4088e47b672a6a79aedd2"
    sha256 cellar: :any_skip_relocation, mojave:      "03baa4d6f79772591dcd0ac5db5a148fbe79633b7ab66de104cd244141fbb0d0"
    sha256 cellar: :any_skip_relocation, high_sierra: "3e194aa8c79d1609040430c5d2e804b69df9ffd4cfd0c0501cdecce249591f83"
    sha256 cellar: :any_skip_relocation, sierra:      "65d77c58ac90e7767f93896c9ec95a478dc1388316bcdafb4c06ed10db089caf"
    sha256 cellar: :any_skip_relocation, el_capitan:  "bbe12dac66d033674840eace741bcf5c3549e7317ab9ca6fa9f349418a6c9861"
    sha256 cellar: :any_skip_relocation, yosemite:    "bbe12dac66d033674840eace741bcf5c3549e7317ab9ca6fa9f349418a6c9861"
  end

  deprecate! date: "2020-11-12", because: :repo_archived

  depends_on "maven" => :build
  depends_on "openjdk@8"

  # Pin aws-sdk-java-core for JSONObject compatibility
  patch do
    url "https://github.com/amazon-archives/aws-apigateway-importer/commit/660e3ce.patch?full_index=1"
    sha256 "9882150c1ac682db36755fc7bcb813da1f7c94b98e3bfbe6fe329de9a3506092"
  end

  def install
    system "mvn", "assembly:assembly"
    libexec.install "target/aws-apigateway-importer-1.0.1-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"aws-apigateway-importer-1.0.1-jar-with-dependencies.jar", "aws-api-import"
  end

  test do
    assert_match(/^Usage:\s+aws-api-import/, shell_output("#{bin}/aws-api-import --help"))
  end
end
