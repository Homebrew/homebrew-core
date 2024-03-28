class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "66bc716763bcb0f55f0ce2ab2a57057232f70bb7784fb4db0e3015a6fd0f915a"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfa13b0c029685e7949510e4cfd769307d19834b5f6e053e8360bf215d35da80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e6f010516788c6a9cbc96a8d87e8f21a60f57aea373401a0e365ba0bc805030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd471e12aae7c8d2b7c38163eaa259e929e2f38bfb715b71a19876c0333a4597"
    sha256 cellar: :any_skip_relocation, sonoma:         "14954df31ab1be2deaa9c2d6acbba430b62a1dee31b2ffc38748d396ea7f8188"
    sha256 cellar: :any_skip_relocation, ventura:        "e76a15549fe154384354931b5b7090190109cf57fa4ed7dfee3f3eda378b6931"
    sha256 cellar: :any_skip_relocation, monterey:       "4392e05c10880ce9bdd88a79d0fc8f56cdc8c6d117dd1641da11cd31c58d8715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06216fcc38bcc4eafe2afefbbaed174e45fbeb07c9631b469cbaa805662ba135"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_predicate testpath/"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin/"opensca-cli -version")
  end
end
