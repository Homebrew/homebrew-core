class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "45e7a1a878ddf34f2d9a09ef4223abe57fa40446033e4b94cc93cb0281f8d93d"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15604818f34c60b431519e6fc1af58b92f1263fa9441a326253f91a7b9212431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49162828232c2f2c588c27a565834935278bac8a6f3a811c0fbc07318900ef4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347c9e649f2259b1f6391a026ca14c45d54349ac163462cc9904e1887abca4ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "798b8658d6784f78c79c2bc1bae8fbb6de0300d80bd5a7e16495ded165409acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b140b4392232bbd30c0ce36054d19b75a5935b563dac2609a656aae9ed3a147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a83a2b3e866fdce381e0881a27118c68d9e69e4724586d3d47245c6c9281abae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
