class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.114.0.tar.gz"
  sha256 "44044639e695ff46ab3ad342b99039030973e5215e3d04f88fdc46b873d4a96b"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2708d24aede03a9034ad1068d63ba96110867ff88429e93a98239fe13845226d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2feed44efab35a446ef58a681831e83071e6319db801a506097b6f30aa2bef21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5135e1bd62700020cfe0c0903e494b75413df115ed33d77da0915d259f61c1ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "de35672bd7a77bc639a4327cd9526cf1a8241ca3a482e1c586df1d3b1ce42552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8044346d554e0b3158820203df8bb728e2caa2f4b01a3ed7cb34e95da92ca9c"
    sha256 cellar: :any,                 x86_64_linux:  "32ff4ca9daec4124a924f9647a12256cc79f1ebec146e3c8b2e08c4300229865"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
