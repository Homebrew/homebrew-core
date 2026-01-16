class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "768212c3bf8f2a0522d3f8f99e655a7c7c1c4c050ef8d660437e08e424afda09"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf0ca474e9606a9c99e3265d4dc793b45b69f5fe0cd981311862fc4bfe7697c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0ca474e9606a9c99e3265d4dc793b45b69f5fe0cd981311862fc4bfe7697c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0ca474e9606a9c99e3265d4dc793b45b69f5fe0cd981311862fc4bfe7697c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f52a102a86d3e3c8c98ffaaeadc0f6f6b992c2a5f1e1855261527a04acf623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7851bf709d3157d45bce15b64c666c1449e36de5c6c8cb9128840fb3e52693c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce437240eeb0d9bc130b5b32c15fd09258ac1580eff89fb7b07096c9c528c06"
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
