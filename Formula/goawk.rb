class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "dccc38d29b552db43262b9876c27e27c7ac0b5658fd34b2866205cdb4bb1a534"
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
