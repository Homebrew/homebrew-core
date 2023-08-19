class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://github.com/apache/skywalking-eyes/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a966e511617fda5628cf3ed816b7152653268f40f3fdba60210f628cf4c75ab9"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f339ed1b317b4808321cfe52277b1d9bfd7d3d03e17778df9fc6346f0a0852e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e08bb9ec8ee2552e03a1d337834c82e91784a05eeaf3e120eb96257a8a826db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f90e9799e968c3feef373bc9b058c92cadeba1d112383044de8b3157f06db1"
    sha256 cellar: :any_skip_relocation, ventura:        "79f1888e1863ed28d1e49f65e1235a163081232a0c8f3530103c0c7a2986a3c6"
    sha256 cellar: :any_skip_relocation, monterey:       "445e3e0be3cef0314058978131b05951d16778ec3204ac7beafe413f17679e10"
    sha256 cellar: :any_skip_relocation, big_sur:        "bba970717efacdc752616f343cc47df5548618e23bae55746aeef05fc0f1bcb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b0e51348d0fe83a655c7976b60fbf689584930b4c40b736d49caa005fc1f14"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/skywalking-eyes/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/license-eye"

    generate_completions_from_executable(bin/"license-eye", "completion")
  end

  test do
    output = shell_output("#{bin}/license-eye dependency check")
    assert_match "Loading configuration from file: .licenserc.yaml", output
    assert_match "Config file .licenserc.yaml does not exist, using the default config", output

    assert_match version.to_s, shell_output("#{bin}/license-eye --version")
  end
end
