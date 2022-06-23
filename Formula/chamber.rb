class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.11.tar.gz"
  sha256 "9461f0366ff84fb24f82072d9cb16443d6bf9d2ff1847548d26d24619991ae27"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64a9308ea7631ea51ac1c1f011ccd8de0fb5cbe7a96562572f4276e0db7f9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2565c4cd16a4660401cac19e3850a1d3dea267fa160d8f2d68d450f5ac7ec97"
    sha256 cellar: :any_skip_relocation, monterey:       "743a03500af20689087d1f045d2432a455f423454d3364a4dc91fe26c33b61d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "72cccbe8b48c44f13d8092e01237f46e2654e2ab68a5b2019a31ad2b9870a80b"
    sha256 cellar: :any_skip_relocation, catalina:       "0865abe7920a1ad2051a181c71126f727c9938df4f46ff668fb9ff1aa448ae6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027f6fa7dd87199c3b32c34f8bc5e788a688bfd553404c9f01494d70312bbf08"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
