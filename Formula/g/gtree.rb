class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "6586b98100b7e78a3850a73407195556246bb2a26f881c6459e65ac3790ca671"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d2ffe6b28faf3ea89073f95ebc71a96d2aec60db1142b05ff834242b65eb28f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2ffe6b28faf3ea89073f95ebc71a96d2aec60db1142b05ff834242b65eb28f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2ffe6b28faf3ea89073f95ebc71a96d2aec60db1142b05ff834242b65eb28f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f954727b3b77aa3d9745d398b8a73a063d11a65b7aec66357e77460238b29da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbda7157c5e9334783df27f5d0744016e23dc0178b4ec606ad8de959f2357041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01a83fc24f8abf2285e09e626f39d1efdbcaf6c41ddecc16711e9fe72ca614a"
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
