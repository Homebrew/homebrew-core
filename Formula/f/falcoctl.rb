class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "d3fddc987ca87f7a690c2b236d8411eb5c9c7ef42af044445159691e490c94fd"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0955bbc36b028b0b1400794ac255de2973bae37157308ecb6cf751c4a0069556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb861fcf7ce2bc257129b3904fd3e9240170317e3db3073e4bc5a8b841255e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "737f18e8031b893a9dcf6a672b96671521b8f2371ee7f19b33489157139af4d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b703dc701a1b1fd1318c86823b00b2b69711d837218ef1570d20693f0d47c142"
    sha256 cellar: :any_skip_relocation, ventura:       "f7a37fae15a5bad4ebea6ba4967249e7efb0f19777e0a1531a46553867ae2a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc68ed59c49be48ea0f6f745b126e56550a2e361a75b34dfd638926dca3ff31"
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
