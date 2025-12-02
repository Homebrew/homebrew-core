class Cfnctl < Formula
  desc "Brings the Terraform cli experience to AWS Cloudformation"
  homepage "https://github.com/rogerwelin/cfnctl"
  url "https://github.com/rogerwelin/cfnctl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8e987272db5cb76769631a29a02a7ead2171539148e09c57549bc6b9ed707be3"
  license "Apache-2.0"
  head "https://github.com/rogerwelin/cfnctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16608ad765e5b6736d2470bf0473b1d2ed1aa6431f6446fe8a7f34f90f496364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d18150beed91b47a03146e5cceaa9d117dbde79fc14bdc923fd32b83443af4e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d18150beed91b47a03146e5cceaa9d117dbde79fc14bdc923fd32b83443af4e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d18150beed91b47a03146e5cceaa9d117dbde79fc14bdc923fd32b83443af4e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f3b8deeefea7efd4bbdc4f7abc993cf90e9c8791fd32bc45685bd290bc0372"
    sha256 cellar: :any_skip_relocation, ventura:       "09f3b8deeefea7efd4bbdc4f7abc993cf90e9c8791fd32bc45685bd290bc0372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d041b39ff1b823af16f06c2e647a5c30d8d9ff0705aefb9791002e0a3bd953f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c656851efb6ce909bc879ba960c4d134c824d725909b01799dea6a29405cfe9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cli.version=#{version}"), "./cmd/cfnctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfnctl version")

    ENV["AWS_DEFAULT_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"]     = "dummy"
    ENV["AWS_SECRET_ACCESS_KEY"] = "dummy"

    (testpath/"test.yaml").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML

    output = shell_output("#{bin}/cfnctl validate --template-file test.yaml 2>&1")
    assert_match "ValidateTemplate, https response error StatusCode: 403", output
  end
end
