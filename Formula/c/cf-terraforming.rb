class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "5109ba7f50a40864eb15ab554ae0b74aa3ac5009591c229c6b1b5079d363be24"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a279f891b3ce513eee2c4f64b529c365878ad5f861c00dca84077f444157e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28683d6606573c88c483e8504c0ceff67e6802bf0c07e4a7204dc0eae319fa20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28683d6606573c88c483e8504c0ceff67e6802bf0c07e4a7204dc0eae319fa20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28683d6606573c88c483e8504c0ceff67e6802bf0c07e4a7204dc0eae319fa20"
    sha256 cellar: :any_skip_relocation, sonoma:        "c22adb6824e29a681c55b087f37cb83d0a8d3bd9027b1263560c9b581b32440f"
    sha256 cellar: :any_skip_relocation, ventura:       "c22adb6824e29a681c55b087f37cb83d0a8d3bd9027b1263560c9b581b32440f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c18622778e78519c038ef000c55909a1c5dd78f58938a1168eee4f9afb0b6880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dafd75c99e8d1865471886ac10edac8df40e8bcb8d89a533ad82003089185026"
  end

  depends_on "go" => :build

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-s -w -X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
