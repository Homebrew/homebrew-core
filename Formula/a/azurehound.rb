class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "36fa980d4b1d5a454b13aa5c6f12de4a10320a656f2badff2239b7070bb33715"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59d39d98ab1ba5ce12168d7371e52bd490c2e42b4402b129016b74f3a84bbe21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d39d98ab1ba5ce12168d7371e52bd490c2e42b4402b129016b74f3a84bbe21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d39d98ab1ba5ce12168d7371e52bd490c2e42b4402b129016b74f3a84bbe21"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6a7bae4a97374c59799e0520960846934f6b23998326ada53cbc87267093aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f1ef3f100dd7560c4bd0d2b6961a8012bc90e40fc5830d5fdc50b60446cfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed962aa3a337253f5907ce81eb473f97fc9c4880cdf8911e59c76e4a3176749b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
