class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "93170305101876b6508f79f84f8a998f97ed7ffb9ec11d363088875297b00f4e"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43daf9b080c466caef450e7e058954cc2f25b794da90ad0184eb3f97f62f47d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "363277496c26f442a65f7615d35d0042ec29f5f6a64eab8952f2891fb469cd3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe2f49a68ef6316074e4f821f81b3eec881d600ee9ada24788b1ad5e7a1af3f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3664074d3d18cc7b1db6ea00d6e3ca56cf9720b360c5a254cf9fc126353d194c"
    sha256 cellar: :any,                 x86_64_linux:      "25a3ad5dda6862fa019357fd3296cc8849de376779f65d66f140cec64483059a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

    ENV["XDG_CONFIG_HOME"] = testpath
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
