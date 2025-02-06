class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.2.0",
      revision: "0dab1442ebb47dd3f8e2ab82beeb328d4f287fcf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9cc38a5167d25fb6d0dc681ee7499ca63a6a494a13b5a4d2400fe72b94a48e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9cc38a5167d25fb6d0dc681ee7499ca63a6a494a13b5a4d2400fe72b94a48e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9cc38a5167d25fb6d0dc681ee7499ca63a6a494a13b5a4d2400fe72b94a48e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "949e70e5db897e81dd855513733f3343e1333ebcb3775221aae729724fffc732"
    sha256 cellar: :any_skip_relocation, ventura:       "949e70e5db897e81dd855513733f3343e1333ebcb3775221aae729724fffc732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd16ad978c9bf4dac80f0932ce1cb128339ea13311aec49ab2b1cfec50893cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/Azure/azqr/cmd/azqr.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
