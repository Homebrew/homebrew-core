class K2tf < Formula
  desc "Kubernetes YAML to Terraform HCL converter"
  homepage "https://github.com/sl1pm4t/k2tf"
  url "https://github.com/sl1pm4t/k2tf/archive/v0.6.2.tar.gz"
  sha256 "e8971e6e7783e8e96014939f67d81570042f147f027fb1eb4c2f524632a68403"
  license "MPL-2.0"
  head "https://github.com/sl1pm4t/k2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6208afcd6be13d5e0fc9eea2835e2695b426bd774364741c96a1ba415b5512c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b965773a6297eed4bd17d60d37bae417c9d9ec5cb9238bcac4b34685a510d9e"
    sha256 cellar: :any_skip_relocation, catalina:      "3924263dbc837f9298c61add61cbe644b6d33050ac230ade1129288d663eaa8a"
    sha256 cellar: :any_skip_relocation, mojave:        "903d5c2de0b57d9ff6a293803e60d44d470774eae764f2b40e4ce92726b471ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc45397267bcd9a6852d68b9a8c14b1269c4bff60f433c91245e9a12cfb25ef9"
  end

  depends_on "go" => :build

  resource("test") do
    url "https://raw.githubusercontent.com/sl1pm4t/k2tf/b1ea03a68bd27b34216c080297924c8fa2a2ad36/test-fixtures/service.tf.golden"
    sha256 "c970a1f15d2e318a6254b4505610cf75a2c9887e1a7ba3d24489e9e03ea7fe90"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    pkgshare.install "test-fixtures"
  end

  test do
    cp pkgshare/"test-fixtures/service.yaml", testpath
    testpath.install resource("test")
    system bin/"k2tf", "-f", "service.yaml", "-o", testpath/"service.tf"
    assert compare_file(testpath/"service.tf.golden", testpath/"service.tf")

    assert_match version.to_s, shell_output(bin/"k2tf --version")
  end
end
