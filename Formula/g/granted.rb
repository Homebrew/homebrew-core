class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "6f9a4b38ffac2da32d7f6c5d225aca2f799d1f74aadd3783a873ff5d98b94144"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6d59cf9cc915f91dce024168c97365a26f4d098dab2913551daad1b5b7134e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ce52b1836d3f0e1ac21956ee1ea1fff166a029919cf5c67fe44c91e04406d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c449b853742d204485d403e84f0c233be8dd162ef317f56cfaee66667c1c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d2149578c19e0861bd906d18e021a56b9edcab77b86e4c146e155f8517c5fb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b7084725cd4bb9b5dc268e329ffe306f0a78aae870534e804338ef85603379f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a953b902ae84eafa539888c363e1389a76cefddb077d80fa76f85ff857e1507e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fwdcloudsec/granted/internal/build.Version=#{version}
      -X github.com/fwdcloudsec/granted/internal/build.ConfigFolderName=.granted
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/granted"
    bin.install_symlink "granted" => "assumego"
    # these must be in bin, and not sourced automatically
    bin.install "scripts/assume"
    bin.install "scripts/assume.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/granted --version")

    output = shell_output("#{bin}/granted registry add 2>&1", 1)
    assert_match "[✘] Required flags \"name, url\" not set", output

    ENV["GRANTED_ALIAS_CONFIGURED"] = "true"
    assert_match version.to_s, shell_output("#{bin}/assume --version")
    assert_match version.to_s, shell_output("#{bin}/assumego --version")

    # assume is interactive; pipe_output provides empty stdin causing prompts to fail.
    # Match varies by environment: "does not match" (with browser), "Could not find
    # default browser" (no browser configured), or "EOF" (when stdin closes).
    output = pipe_output("#{bin}/assume non-existing-role 2>&1", "")
    assert_match(/does not match any profiles|Could not find default browser|EOF/, output)
  end
end
