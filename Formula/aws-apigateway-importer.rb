class AwsApigatewayImporter < Formula
  desc "AWS API Gateway Importer"
  homepage "https://github.com/awslabs/aws-apigateway-importer"
  url "https://github.com/awslabs/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "1aecfd348135c2e364ce5e105d91d5750472ac4cb8848679d774a2ac00024d26"
  revision 1

  # Pin aws-sdk-java-core for JSONObject compatibility
  patch do
    url "https://github.com/awslabs/aws-apigateway-importer/commit/660e3ce.diff"
    sha256 "0dcfd1e03d653708726672dc6e6bf6f4b3e5d0184a75f224bf64f9bc7974b931"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "65d77c58ac90e7767f93896c9ec95a478dc1388316bcdafb4c06ed10db089caf" => :sierra
    sha256 "bbe12dac66d033674840eace741bcf5c3549e7317ab9ca6fa9f349418a6c9861" => :el_capitan
    sha256 "bbe12dac66d033674840eace741bcf5c3549e7317ab9ca6fa9f349418a6c9861" => :yosemite
  end

  depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "assembly:assembly"
    libexec.install "target/aws-apigateway-importer-1.0.1-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"aws-apigateway-importer-1.0.1-jar-with-dependencies.jar", "aws-api-import"
  end

  test do
    assert_match(/^Usage:\s+aws-api-import/, shell_output("#{bin}/aws-api-import --help"))
  end
end
