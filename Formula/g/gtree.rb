class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.7.tar.gz"
  sha256 "3f181e59ebcb99d01c3134f2154b92ab884ddaa226c7d4cbdf5314ac86830778"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce4bd2c5e622925c8e7f01e4108ccd3104287037512afcceff9c05d1e71f96b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce4bd2c5e622925c8e7f01e4108ccd3104287037512afcceff9c05d1e71f96b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fce4bd2c5e622925c8e7f01e4108ccd3104287037512afcceff9c05d1e71f96b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3720ddf110e59fb100d3f31fd8e9e0844bcb93be13fca24ad084eb577017fa18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705c78dffc0993afd1c4c6b685bb8e2090fc6f6c18ee43b37bb09b41cd144ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3fef881937f104ad9d4291c8a1d366527b2c211196a5cc389353d130a974e3"
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
