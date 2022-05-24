class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "25eeb7ac7f12fcb9f20845d8f340ab74dad24e467761f9658aaa3f864319c036"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9083daeb922bb4916f229dc688175f08ae882eb4cd99680de75a29df57fd288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7004a3c3518099f33202eb1031a022f9c331209f5f5f4b49276110f02a4c7d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "5e7e8e0e8bd9286b4c9b83b08606303554f32b5391074c8a47c3a1aac1dabfbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce1252568594868ec0484fad9d13de6121a15701b8e2d87ac421a6b75b813bf2"
    sha256 cellar: :any_skip_relocation, catalina:       "d5595f9cfbb9e40be0e3c70cb35d6121151eb305efe10a522473775b25577c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72503c041ff65c575ab66644f347c3f003d318ac78eb4a2f2151e73871a90b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update 2>&1", 255)
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
