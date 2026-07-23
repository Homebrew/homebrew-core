class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.6.tar.gz"
  sha256 "d631355eac772b05633484bb273bdce498ba768b6eb6d5756896de57743d0813"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd32025e61323699e8ebbe8eca243590838ac876bbc9a25aa48b0165fff901d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe42b6f2f592b353ce9b051dfb580b743ddfaa9f1291dc40503ef2871d16753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19835d661c2adbfa6a3c854a2734608e6355f7e490cfbc6db8e86d0b15511096"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f38caaa743f3caaa909e671221f1faa0f380b381beea690c8dcf737fc815902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865e0da1e3ec3e3c6c8af8fd7fa6502e34e9a03e278f80810496d207fbb9eadd"
    sha256 cellar: :any,                 x86_64_linux:  "383fb9206eaa00fc7260880c7cf396c5d11956e2e691d25427b4ba3e734a02af"
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
