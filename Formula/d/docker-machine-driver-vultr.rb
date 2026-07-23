class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/vultr/docker-machine-driver-vultr"
  url "https://github.com/vultr/docker-machine-driver-vultr/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "451a6e31ab4e5fb9be2c2730b1b03f5039a8ac2b41f677824e1b8a15036ab815"
  license "MIT"
  head "https://github.com/vultr/docker-machine-driver-vultr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a2113c1e6022f95fd189b597885b1dbd321584adcb48558d5918d8b8c3b82d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a2113c1e6022f95fd189b597885b1dbd321584adcb48558d5918d8b8c3b82d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a2113c1e6022f95fd189b597885b1dbd321584adcb48558d5918d8b8c3b82d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "803bc1f9822027a2f45a6a2713a13f9eca07b17fa4e6b8902f665cd30b388555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15d423cb1c6f861f95de022a8df429df7abc0e9684601c03f068eef9b062c72c"
    sha256 cellar: :any,                 x86_64_linux:  "0a716e6a759a224d1d94a60b87a7565f7bce54a671f7420170a5dd095739e263"
  end

  depends_on "go" => :build
  depends_on "rancher-machine"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./machine"
  end

  test do
    assert_match "--vultr-api-key",
      shell_output("#{Formula["rancher-machine"].bin}/rancher-machine create --driver vultr -h")
  end
end
