class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "e7ad86f4851582bd75d3628307a2cfb84fad7c764bd235d6558b833ac778a188"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa1f661e14b65c477b691c42806c9c38eb5cd37ad9b4196ee31abda595ecae0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa1f661e14b65c477b691c42806c9c38eb5cd37ad9b4196ee31abda595ecae0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa1f661e14b65c477b691c42806c9c38eb5cd37ad9b4196ee31abda595ecae0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd0bed85efe7213e52cff5b62d6491d2622cfe050ac402f27aa990d1fdb20b65"
    sha256 cellar: :any_skip_relocation, ventura:       "cd0bed85efe7213e52cff5b62d6491d2622cfe050ac402f27aa990d1fdb20b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fb2591d37c6a67791076524c6652dd9848021e0f8ffa9a545c02d3a4a98878"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
