class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "8bb7661e1ef33c6aa128fa999a044bb4a4fdaffc808e3522c3722c3ad8881d9f"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0563b9fe1c07f725615d41dd5a2cdfca45b94cb985af4890f7d8677b7688c6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d6761c3e56228bdf0e0e075362d759c49bab0929f0416fd2911d5520912656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64d6761c3e56228bdf0e0e075362d759c49bab0929f0416fd2911d5520912656"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64d6761c3e56228bdf0e0e075362d759c49bab0929f0416fd2911d5520912656"
    sha256 cellar: :any_skip_relocation, sonoma:        "caea53081e59a5406172f0fe5640f09b0304270ed0ed5013415eb376c1c8c7fb"
    sha256 cellar: :any_skip_relocation, ventura:       "caea53081e59a5406172f0fe5640f09b0304270ed0ed5013415eb376c1c8c7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6aab27387ad1dc6345cb5c9d6e33b0857868b359f11cdc4aa3fc39dfe07dee7"
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
