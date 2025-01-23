class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "a523c41cbe3ea9167a5699ebd97b2f0af7fa0cddb8102e2008bce05b80b8f7f5"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59e3c05d2e9a55b2b2352c6af3b0a1a9ffbcf082cae6fcda36e68c14fc99673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47672eff56944d66361e531174e593e4a88f685e74c625bd78d5d250e8247f29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81abdb7a3443aa86d381eab2d983a95de5c69032620a16e4bfd73145035c476c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5b97d0871e16f36a9455704f6e02df21a68c1a2c88e6e093bf8da7534c1210"
    sha256 cellar: :any_skip_relocation, ventura:       "ab1485cec967215a89c465e678b73b65d571877f54bad2be1b582131e28a6304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5977c32e9872c26e347f4a2b0a2463cd3ee2caa39e9540b39fb47ac21738f1e9"
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
