class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "b6e2bc8fda38f55ee4673cc0f3f762e076d2029df1d9a8552681a2aacce88721"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "905d6f692d85563eca73585449c2936f5086ce5cc1cc1e101a3bcd71ecf1e8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "826f554acd21683c694d7b3ab363aee7a5339b9f488c8672b723494557dda323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d6a65dc8bcb372ebbbdaee1ce5d47f14adec08b67b2ff8d6a6c28da6d29e8ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "2082c978cba759a2f55bcaa9e1afe102dc6bd03687deba376b075b043158358a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ecdd52db4973da236d1317fbcd89309dd0ec5e36da27515463e29383ac423fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9dfb7396fd9de587fabb3b7fa0246efdf9155a5c2ed32cf5ec2fab0d27848c"
  end

  # Formula does not function properly without additional shell wrapper scripts
  # that must be sourced into the user's shell environment. The upstream project
  # maintains a third-party tap with the complete installation:
  # https://github.com/common-fate/homebrew-granted/issues/2
  deprecate! date: "2025-10-15", because: "requires shell wrapper scripts not suitable for homebrew-core"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/common-fate/granted/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/granted"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/granted --version")

    output = shell_output("#{bin}/granted auth configure 2>&1", 1)
    assert_match "[✘] please provide a url argument", output
  end
end
