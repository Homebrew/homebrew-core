class Mob < Formula
  desc "Tool for smooth Git handover in mob programming sessions"
  homepage "https://mob.sh"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/5.4.1.tar.gz"
  sha256 "6f5b534887cac436f696e38e488b481b38c6cb1c3ad3860e56faf8e87f858344"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086f5ffec348d1ac11b75fe9521a5581466d54069d6be0734d44ed378c5d89f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086f5ffec348d1ac11b75fe9521a5581466d54069d6be0734d44ed378c5d89f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086f5ffec348d1ac11b75fe9521a5581466d54069d6be0734d44ed378c5d89f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0974903ce2af25f109e4f8889e905f27dde5a201c2dfeb03fa8e914fdc415c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd8edcfc7f0b9837ab6bd96ee67c79171d89664e4e6b83416761f08b65e4a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277ccddb45fc4ff59bcf5dbfd4ae88c0e354d37dbcc1ce5a208cf12f7bce47d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mob version")
    assert_match "MOB_CLI_NAME=\"mob\"", shell_output("#{bin}/mob config")
  end
end
