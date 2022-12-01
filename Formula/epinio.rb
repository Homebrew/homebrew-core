class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e7366805e5125fa5ef40d6d64b59ed3a23c32c2ae4d2cfe9f8728ccb2747fe43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62fa19622acf35ad4c14b45c0e831c93ff5dce1e21d5ec03210a4d9493a7957d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92688b8d37f7ebd021750f76a6b77d4fa3b4dd499fe783b11f5935493c68b66e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccf1cb26cb5a4af28a2916e823af6c51d73569164583b88d2649d0c8a88306da"
    sha256 cellar: :any_skip_relocation, ventura:        "9ed4b816fc976ac4d7a3de1c4479e2f62650e2ac3f74ce815a8fc6c4f85e6bde"
    sha256 cellar: :any_skip_relocation, monterey:       "5c6d1eab60ba43716192bbbdcf70ae07a0475f9b0ecad25825fd5fc219dc626b"
    sha256 cellar: :any_skip_relocation, big_sur:        "59aec3058b61e835f41af499bd1bb7b5dac64eaa326c930edd03008e6ef7f2b4"
    sha256 cellar: :any_skip_relocation, catalina:       "e00e09b5c9adb98e727090914b36d17c52d50fd903282028660a1ed41fe7dc1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44b87eaa00209c47a49c5e69135a49d25b005b2166abf955fd40140eb2841bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
