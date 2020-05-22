class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.8.2.tar.gz"
  sha256 "7f471abf96c92c619641d7a3fed130cddbd815c9c15fe2f151e6c981f5706584"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0ceb203c12953d875313d387cd582d00e5dfbed6ca760e7269150664761f64d1" => :catalina
    sha256 "10a9e719bfceb41c8bf8c1f04fb0bb5ce6801bc2f2980ffbbbd8a679bc004da7" => :mojave
    sha256 "9e1751d1e0b17662b99d9978fba14f83f8891ef0392bb62a0cfaf25566da20b6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=v#{version}", "-trimpath", "-o", bin/"chamber"
    prefix.install_metafiles
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
