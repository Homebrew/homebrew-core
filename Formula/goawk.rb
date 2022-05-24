class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "6d90e60364026445b028c6bc3ff9ed3745f87764e4f9b6688cb498d0639a65f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffca1080c0ca35f77370f8a45b6f111845f8678320ec296287c1f81a48e1164b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffca1080c0ca35f77370f8a45b6f111845f8678320ec296287c1f81a48e1164b"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e8b966321ba76510172b2342ee367a4e68cd35b5f90a10dcffffcf344f84ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e8b966321ba76510172b2342ee367a4e68cd35b5f90a10dcffffcf344f84ab"
    sha256 cellar: :any_skip_relocation, catalina:       "e6e8b966321ba76510172b2342ee367a4e68cd35b5f90a10dcffffcf344f84ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfe2d7a347a290b836d58642a64cd926ab8ef19118f6ad19eb78dfd8276cddba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
