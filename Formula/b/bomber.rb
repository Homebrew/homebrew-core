class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "f4d8165ea9d3be0e88fdb33d35870588df308f31a4c40f14f09f0b68570f6ae1"
  license "MPL-2.0"
  head "https://github.com/devops-kung-fu/bomber.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b7bea8527dff512ea3d05b41ef3a63b9cc0ab3e36d6a700d8f49f427dd7f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b7bea8527dff512ea3d05b41ef3a63b9cc0ab3e36d6a700d8f49f427dd7f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16b7bea8527dff512ea3d05b41ef3a63b9cc0ab3e36d6a700d8f49f427dd7f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a897a38cde09a42551fde0010301b17b41334ddb261a6386249704ce8a9741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de74c0ad4a15499fcfaf276562b2821aec6f030ce81fe2897886b6dad93f417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8041a282f0b4ec4162f928c91a501a1ad1e95a64b28fb21b771e2d2d357ddd6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", shell_parameter_format: :cobra)

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json")
    assert_match "Total vulnerabilities found:", output
  end
end
