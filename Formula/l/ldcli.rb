class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "143b24e440c492b145e638b004e9927aa198c3bfa707494466a3ee010649be64"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccb11a95afb033e009e78b8897e4349e228498de8d508f60ded832ce3a460145"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fc4eeabf6d26fce2abe6a62e4984dba17ae1270bfef59c13b0c8839a0458d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f22a0071ceb475502a0f44dcbf89a498a656f3d4598026b7743abe4961a5e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9a52ce8c4574c9951fa5510649a4989f1d8d4a4b920aee49e801624a058735aa"
    sha256 cellar: :any_skip_relocation, sonoma:            "32dd88353ea3ba96a48a492091c60aea61299dce72e0feb05023957c9f4a43be"
    sha256 cellar: :any,                 arm64_linux:       "09fe6881cf1678776d77c9ff8b2661b760bcfe3a7bc3a82b3d7ac94dd12e0528"
    sha256 cellar: :any,                 x86_64_linux:      "e3cec92e8af7b1a117b7d61f988a69ae469aac28829efc0b516eb57c4643d918"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
