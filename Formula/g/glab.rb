class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.31.0/cli-v1.31.0.tar.gz"
  sha256 "5648e88e7d6cc993227f5a4e80238af189bed09c7aed1eb12be7408e9a042747"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e73524705544761e93f010dfb5a25a98f9415325d0350c6ea5a8a2d81b3b5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e73524705544761e93f010dfb5a25a98f9415325d0350c6ea5a8a2d81b3b5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84e73524705544761e93f010dfb5a25a98f9415325d0350c6ea5a8a2d81b3b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "eb91549cec512f4fa6d1c500aba0ce20375a850f81eb2a158b6c30b67d35a433"
    sha256 cellar: :any_skip_relocation, monterey:       "eb91549cec512f4fa6d1c500aba0ce20375a850f81eb2a158b6c30b67d35a433"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb91549cec512f4fa6d1c500aba0ce20375a850f81eb2a158b6c30b67d35a433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734384fd51d4265844312dc7b0dc3b1a91536c60ee877b10ad3d2babf038dd15"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
