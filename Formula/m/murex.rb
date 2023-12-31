class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v5.3.5000.tar.gz"
  sha256 "01dd4cac5d71692c0bb3724c543f6a2a45259f0199249335f94511f3509d7ebf"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ab6a033269152793750e1c733c96b22cb74d96212f50974d35edad53b352b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b4e03822a51f1b6da0e2e0c88000165944fe57f27222e8719377bbf399c9de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7cdaa7821102e2950838e4ca04955d1951902b772abbe0266f1be7e698e111a"
    sha256 cellar: :any_skip_relocation, sonoma:         "db94ae4219ac39b8d3017a08e27c4756bb0d8aac362ed8aa9146a85d6b5b4683"
    sha256 cellar: :any_skip_relocation, ventura:        "21bb6ab3a3d6a39c7734b04473ddd8941fad2a54293d8c236f12a2da4f9fc89f"
    sha256 cellar: :any_skip_relocation, monterey:       "46a0996431bae0d0421db91a07f564f6863289f8f3bd213231be84a9fee4e237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a24b3c0c983cb341e8c27aa3e728a17305eaac006a6be41e1fe427659d9fc58"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
