class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr"
  url "https://github.com/Azure/azqr.git",
    tag:      "v.2.0.4",
    revision: "4891102e05bf35064017eacdbc5415b92a39795e"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/Azure/azqr/cmd/azqr.version=#{version}'"), "./cmd/main.go"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output_filter = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output_filter, "failed reading data from file"
    output_auth = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output_auth, "Failed to list subscriptions"
  end
end
