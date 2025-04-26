class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "c479031e407182fe45da852d59bae529aa7a1bb15410f64fe59bae6f959ebd83"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1eae0a9d240eba30b6d8e5eb44fc7c8c1189175239dc622203d208fcfe5fbde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1eae0a9d240eba30b6d8e5eb44fc7c8c1189175239dc622203d208fcfe5fbde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1eae0a9d240eba30b6d8e5eb44fc7c8c1189175239dc622203d208fcfe5fbde"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f719ef4cac83d1364ce970e46cc0f0bda1de888f1cce23e950f2a41eec2b9ca"
    sha256 cellar: :any_skip_relocation, ventura:       "9f719ef4cac83d1364ce970e46cc0f0bda1de888f1cce23e950f2a41eec2b9ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da025a6020a3676d11190f75c315a9924c8bd5fafbfdbb0aafa04aed6ed8814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389fa5d2152af9f330ab55f0830d022e9b7157445229a360fa8d31e87d80ddd3"
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
