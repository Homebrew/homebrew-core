class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "7bcd5052bd754a61e326d644d1094875fe51f174f94794583d1d1966575000e0"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad1167f93d1d86040408c1200a923907feac5d467032fe0dfe25c92d3b7d8b5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7def7056b9d48ef2621420fea1cbe9b99d3b80918fe85d921ec942e34e02e401"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a20fff5b4fb576ff589f23baaf61d6ec3eacd6d33c516e536f960fd52144a790"
    sha256 cellar: :any_skip_relocation, sonoma:        "72a12abd7850ccb5bfe333e93ca61449c2aa6e1328c43952d4342e6f49e57222"
    sha256 cellar: :any_skip_relocation, ventura:       "3004f549ae78e8c02c5dac1c0d251a6fa314cdb1bb4788d3f999f70c5bd173a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3efadaeacfe8f5eb1ff3dfe61712329a33e08fd8fb064ff9bf17293fc48bc47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48cde85533ac9590ea76a153e7072fdcb2ca0357453758155b1fc1c160ef997"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
