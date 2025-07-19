class AwsSsm < Formula
  desc "CLI utility for managing YAML ↔ AWS SSM Parameter Store"
  homepage "https://github.com/mbevc1/aws-ssm"
  url "https://github.com/mbevc1/aws-ssm/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "f64a7f7d600eec11fcd817ff3328c2bceccef24b94a1fd8df4407b9dc79c7978"
  license "MPL-2.0"
  head "https://github.com/mbevc1/aws-ssm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}-#{tap.user}"
    cp "-a", "aws-ssm #{bin}"
  end

  test do
    assert_match("Error: --prefix is required",
      shell_output("#{bin}/aws-ssm save 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-ssm --version 2>&1")
  end
end
