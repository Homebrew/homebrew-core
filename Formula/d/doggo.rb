class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "2aca54791810246bcc90380f194c2141392f7596c5f17734a6b20bf85a3d7384"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d71e5f1f0343b075d9186fada93a221f6f098ca0fecf9671a78f4bb6e1591350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d71e5f1f0343b075d9186fada93a221f6f098ca0fecf9671a78f4bb6e1591350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d71e5f1f0343b075d9186fada93a221f6f098ca0fecf9671a78f4bb6e1591350"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7e605d612639687d7c2de94d89e64080ce64377e65ae5963b3422ad94b2e7e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70077a8f23d0090ba3dba9c928a6dba8a57dbebfa9871e99cc56b60e97acbaff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1c045bc7b9ab9d2552ebcb8d43f425ab1b199f8f1c5a9355eb66f65010a9b0"
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
