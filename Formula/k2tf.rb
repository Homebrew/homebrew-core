class K2tf < Formula
  desc "Kubernetes YAML to Terraform HCL converter"
  homepage "https://github.com/sl1pm4t/k2tf"
  url "https://github.com/sl1pm4t/k2tf/archive/v0.6.2.tar.gz"
  sha256 "e8971e6e7783e8e96014939f67d81570042f147f027fb1eb4c2f524632a68403"
  license "MPL-2.0"
  head "https://github.com/sl1pm4t/k2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4f70b9f6cb6e6b5a65a84e275f6f8828b59519644700f238c944d2a0343c8bd2"
    sha256 cellar: :any_skip_relocation, big_sur:       "50ada2c6baf47bc0bf56d7c63075cdc0af7c45efea79589c0bce09d548446247"
    sha256 cellar: :any_skip_relocation, catalina:      "3c6750d654d370237d0022ef6fd7cfd712a0b8cfd38ce07f6a9d727b5b87f12d"
    sha256 cellar: :any_skip_relocation, mojave:        "674611d24e1b4eec0d82686b350e1fef1164c978a9748e84191085caaf97c08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71eca44dfed4d097f4735be06e1eb6842479dbbd4428f37b5bb42614b7559c8d"
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
