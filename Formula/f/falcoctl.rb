class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "f6371a5992d26e88e15923cdaa29695f981c6fdc8caafc424c6bb75c946cd467"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a6828d39f561888f7aa5cd71ba07cdc502287e25a70476457ebee88eb987bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15a5627f97acbba72392518a6f592af5f94f4f6129678ee5781ade8e7859e5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73618d1cccae7b53c4ea1ce1e5989642fa458fe2b1ecad0c66525edc3340d63"
    sha256 cellar: :any_skip_relocation, sonoma:         "c17b68409590ad8f69a96af36872817aa0ae687ad417b64ddc0146d0abf32dab"
    sha256 cellar: :any_skip_relocation, ventura:        "914088c6b019a261ab1f3beb9d9ec66e62f214c481950418ef9b753d2bb6ca15"
    sha256 cellar: :any_skip_relocation, monterey:       "c6323818e74f486e08d8ffcfb6c02bff24ea76ea49d99a02f29d1cbecd9e06cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c72830842d89635442ed5ab76a41914b58cdcd4b66bfddb6ad2acc0fbcaa60"
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
