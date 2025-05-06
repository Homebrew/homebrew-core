class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "e7e033c6329729edf0b5640d06cc12d40d9f7b2ca8df733b1ba468206044eabc"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b978a7cb8d1d14fab89a3799e6bcd1a8c38278e4424275fc3ae79ba3a138e235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b978a7cb8d1d14fab89a3799e6bcd1a8c38278e4424275fc3ae79ba3a138e235"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b978a7cb8d1d14fab89a3799e6bcd1a8c38278e4424275fc3ae79ba3a138e235"
    sha256 cellar: :any_skip_relocation, sonoma:        "4627a727d891901de873e80210407631af21dd3ca3235905d59a1d27860ccc69"
    sha256 cellar: :any_skip_relocation, ventura:       "4627a727d891901de873e80210407631af21dd3ca3235905d59a1d27860ccc69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5a627e1f44d9403b2cd46f93dccd4d1de50fec4f841635b0ebbc80a5973fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650440dba22014109f5e1d03ae3a787ad90e34bfb4bf6926d6d5c83322bfec40"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
