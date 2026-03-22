class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "9c66851f4842229fbd4c92e021c3f2929889bc0e2484ef1ea5bf96a553933d86"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a92572f5f98ea7b505e7b58ad60c5053349b1cbf07ae50b67422f3fb103047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a92572f5f98ea7b505e7b58ad60c5053349b1cbf07ae50b67422f3fb103047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a92572f5f98ea7b505e7b58ad60c5053349b1cbf07ae50b67422f3fb103047"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc47ff9f28ad8d24fed868642d2c2d88875b379ba145ee79621632111c0adbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "252836f41e842afefc581f452e935b21732a100a941a4751265aeac275c3072b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dddf3d1282aea78572d168a80b0dbf8d47705670944bc35746aa9302c58c2db6"
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
