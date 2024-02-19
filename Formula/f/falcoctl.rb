class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "d7114c77af92ec413859e152753ccd33fbc297de6964c5c8a8a214476f727d39"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d9d73dbd9d4ee5f3b2d5b20f2c095c2c300ee2363c0d19930d1e68ef7f561cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76f82c5f880e8a19eebc2d6ec22380452c660c3a5b8f180d84792f92d4c83312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d32e97f2ac389431567f30ccd34096f17ca9412a46a00a61e25684f2954d1f81"
    sha256 cellar: :any_skip_relocation, sonoma:         "560d60564b5356489aa70961917f3839632c586b08767417838207463547b3b0"
    sha256 cellar: :any_skip_relocation, ventura:        "ea451491c6704e39e80da60c8aafa6793d1f545797de76cd2c5c190226a62a6a"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad1fb36a9a1bbad4a62095a4d21c61a9c8bbd5d5859597ade12124d3ec49b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ad8f577fea2a54921d93e018aa909afcf6d4d9e0bb3e469bb5a94513345d10f"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
