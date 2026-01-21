class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.31.1.tar.gz"
  sha256 "22f875a6deebf344799ebf99b28e1a0b1d7315b025b0d5d5f17ed99b1bcdf408"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7241199f66ef7d5429fe66c6a57d08505731ba12bf05ab5bed895915ed8888a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e8ddc95b273f7af862b3857b9056a5d88c6985a6755170f8f38fc0ac01a759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed99e4ba1d6f3abbb1f6d3234c25fed3fe18d5a86560d02286d6275a0a6a88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "055eccbee8426ddc55df940711de6229eb1c65e965539ae1fa32cad478e1577c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c44d3003e39ed3fb565e5f3f328e7d2f83e3678425f1c026de44fb2d1e850668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5afa4a21789ad70b1c21c5f841afbd951f3a48dec484e38cf4c90f4aec5a8bdd"
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
