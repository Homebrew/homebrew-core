class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "697d21704aba1425d09730d3aa811e51c53ef3e912fef1da1d9f5f8005dea5f8"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252998cec453ade622f0350d8149f2304203dceac12ade3f38c0a021b98356f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252998cec453ade622f0350d8149f2304203dceac12ade3f38c0a021b98356f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "252998cec453ade622f0350d8149f2304203dceac12ade3f38c0a021b98356f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "629af6683741fb3d7c7897887b71a87b3abf7610a8fab458e5ece99720f22dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "945d1b073bf7bec8628f9d42f3168449f7b413f7dd14780cf06ccdc9af2d23d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d545236aecc498201400fe1509c8dc00fbe355d9fcb20a61c91426fd20b5879d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
