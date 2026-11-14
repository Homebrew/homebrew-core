class Mob < Formula
  desc "Tool for smooth Git handover in mob programming sessions"
  homepage "https://mob.sh"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/5.4.3.tar.gz"
  sha256 "06c28a01ea0f88bbdd5f203ffe42e5865e42d04ff2374c3699fbb1c0ea82ae9d"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21d36aa5cb1cfa6bf3d7e3dd4d4d687619a5baaaf4e1392e29a10afa54d88881"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21d36aa5cb1cfa6bf3d7e3dd4d4d687619a5baaaf4e1392e29a10afa54d88881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21d36aa5cb1cfa6bf3d7e3dd4d4d687619a5baaaf4e1392e29a10afa54d88881"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "602e5a00488058b353935734e32356a1588c5c90930e32bf6979f9c6408fffa7"
    sha256 cellar: :any,                 x86_64_linux:      "1265685b0873abc20c083f410ed5458c22424b363ba8e7110893f6178617ba59"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mob version")
    assert_match "MOB_CLI_NAME=\"mob\"", shell_output("#{bin}/mob config")
  end
end
