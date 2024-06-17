class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "41e1a05f413db93d829d8f108d9060c70734d04cbe53b778a6c5da3df2f69957"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "883c8b958b3f75e3d7312980bae933dfb1301fff90c3695bd68059e398084a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4784b59f42a537a5f88434e55ae4a2386cd4c2a973eecf8adf785b97f4076fd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee1ad620de1f67c8e1dcf67903074eee1b40767b8673b8895296d775b5aa47a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6d57d4c010671113ad0a2e98b4708b58652a3d0e3d5be686bbf34400e82df96"
    sha256 cellar: :any_skip_relocation, ventura:        "3cf7a64d1767fdf0a154989f6a0745b5b71706c9e7af2128a9efd2e1409afbc3"
    sha256 cellar: :any_skip_relocation, monterey:       "5492464d717d5635ead84b948b71c17a6d71fcdbd296f5781fcb80070565eafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b69776d1c45187e9b2f8d5a93992f1d46b6bed800d49e07886174f5aea37ddc"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
