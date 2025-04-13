class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "8fddd9273322e2c03130cbac102c39a30625e8f2328ffe605023a8a39f204582"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b0aea6dc9b4c96b57f9d87b19e979b92a7ffc568a4611a7b37eb30a784a163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96b0aea6dc9b4c96b57f9d87b19e979b92a7ffc568a4611a7b37eb30a784a163"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96b0aea6dc9b4c96b57f9d87b19e979b92a7ffc568a4611a7b37eb30a784a163"
    sha256 cellar: :any_skip_relocation, sonoma:        "a730ec6186cb2948ddd5bd5cdef911e03e6cd13f28a2248f9bb17aefd8b56c5c"
    sha256 cellar: :any_skip_relocation, ventura:       "a730ec6186cb2948ddd5bd5cdef911e03e6cd13f28a2248f9bb17aefd8b56c5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f753d00d56c964204acacc12c862347eaf2f25393aad9c0289982b6e4687f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c134cf0559c13edbc5f20aea793a66b7e7c30ba41f8d60d81893e02555c9723"
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
