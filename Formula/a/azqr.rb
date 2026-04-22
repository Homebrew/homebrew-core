class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.1.2",
      revision: "e7afcc5e5d260795397409377b282a22bf5e8ecb"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5e054ac8583eda9c9768f5a92a68e3e8cde02e354509ba88572c754b64fac5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e054ac8583eda9c9768f5a92a68e3e8cde02e354509ba88572c754b64fac5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e054ac8583eda9c9768f5a92a68e3e8cde02e354509ba88572c754b64fac5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf36777c035718e6bafb5bc6c5fe033131f0234c4284db52bad6fa3e73706b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58167ef62e2448efce95f7f22f57b526d680871e5167ecc0142fbe14f5005ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e084003a15aa7998cbe45025c6d282068bd3d2c8d0075abe35794fb73312d95"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
