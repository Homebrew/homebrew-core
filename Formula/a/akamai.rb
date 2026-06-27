class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "5f0d5217e3434fc57bfc821519379a1705ed749ae754853ea1d40ff65e21eb69"
  license "Apache-2.0"
  head "https://github.com/akamai/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dedaaaa6a7fcfc8572806b0d144c2247d6c0183e5c61e4a2eafd0a226b1cd6fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dedaaaa6a7fcfc8572806b0d144c2247d6c0183e5c61e4a2eafd0a226b1cd6fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dedaaaa6a7fcfc8572806b0d144c2247d6c0183e5c61e4a2eafd0a226b1cd6fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7dadc36ca24042ac563d79c38702241441c3e612068fb4d5dc0cc8cd560c4d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d9bbb4b17ea216ee17f55fb8a1ee62bc5da795a6ff31d06e79d5c42026db70"
    sha256 cellar: :any,                 x86_64_linux:  "f31fa9703eff54b8664821e7c16644d405cd9976635abe2e273dae0b46256a64"
  end

  depends_on "go" => [:build, :test]

  def install
    tags = %w[
      noautoupgrade
      nofirstrun
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
