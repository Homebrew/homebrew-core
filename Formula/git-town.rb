class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.4.0.tar.gz"
  sha256 "f9ff00839fde70bc9b5024bae9a51d8b00e0bb309c3542ed65be50bb8a13e6a5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81f31ec12cd8abae36633570d7bfb4649e880c13b9312f30009272f6d8b7afe1"
    sha256 cellar: :any_skip_relocation, big_sur:       "95e2d5299980978b1901814ada3baa3b42a5c38474e042f891ba0aff10bbbeff"
    sha256 cellar: :any_skip_relocation, catalina:      "9c90e21d837c016a37117bbf04a6cb66e5acda6ea129dd7013a133cbf3e23d72"
    sha256 cellar: :any_skip_relocation, mojave:        "f54ad1a3ad30a40be97995c2a8abbecc447e4d93966f18fbb43fcfaf65448bfc"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2ff4e78e7a3472caa0f5961996efd2ef9e4cfc82455363dfb4f9eaebd441cbe7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/git-town/git-town/src/cmd.version=v#{version} "\
           "-X github.com/git-town/git-town/src/cmd.buildDate=#{Time.new.strftime("%Y/%m/%d")}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
