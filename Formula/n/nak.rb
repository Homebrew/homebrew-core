class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "3b713801dd52d735b2679d2ab90636f3bc9a5c6837465377558aa726c7294e79"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43f80130da2bb51907308374ec7cebac9c89a9c7aa4783569c979bd58000298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e43f80130da2bb51907308374ec7cebac9c89a9c7aa4783569c979bd58000298"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e43f80130da2bb51907308374ec7cebac9c89a9c7aa4783569c979bd58000298"
    sha256 cellar: :any_skip_relocation, sonoma:        "89acd53f64abc97a137fa856b764ba9af2fb39c19a43d45e79b9c8b21d56a934"
    sha256 cellar: :any_skip_relocation, ventura:       "89acd53f64abc97a137fa856b764ba9af2fb39c19a43d45e79b9c8b21d56a934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af24bf5f521b173bd4a89ef9b13cd47129c17ca986631c91a7cae16a32fe9db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "\"method\":\"listblockedips\"", shell_output("#{bin}/nak relay listblockedips")
  end
end
