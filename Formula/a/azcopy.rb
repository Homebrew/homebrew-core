class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.4.tar.gz"
  sha256 "7be97b7ebd84ca3bf80c1e158bf8f8b385745bc95468486b584f00e4a97897d8"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d1bf091bf97bee28207e94fb097fbbc8ff878efb42a55df80609a3e909102f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f2602bd20c5d1eae53fb7eca222f60c3ded53c068f04337c93af7d74d13ec12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a905266ceb80c5cf544f151ef0fb442578665f5b78a9a2c7378b0b3bb4f4ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "82802df3ad22b7e59e87290290c90e2e35a900b47034987c4158ef704404ec91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f664673377ca06b69d241e91c82f7313183f73894b4af1b9a69af82a15e2bea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a283b4c781a7c2c270e1cf459fe3ff367ac35adc67e5c79aa512b37611b95a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
