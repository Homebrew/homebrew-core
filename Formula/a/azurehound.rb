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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeb73cfa276f63ee643441baaff4160710bd73dc972ced9f8c0b67e09ff99700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeb73cfa276f63ee643441baaff4160710bd73dc972ced9f8c0b67e09ff99700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeb73cfa276f63ee643441baaff4160710bd73dc972ced9f8c0b67e09ff99700"
    sha256 cellar: :any_skip_relocation, sonoma:        "46926ac2a92c85559fa8066f2ed8bee09e32ee39532fa3bb6cff59a681a2268c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189150a0291fbc90c0bdebc1714caad86439fc83ee1a62481189ae7e586a870c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d75cf61783d9cb0e45d1159076ff43c15403ede7a15dd57fcfa466150e80cf"
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
