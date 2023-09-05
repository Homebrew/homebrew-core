class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.7.1",
      revision: "8ca42c032317abb81347449ae1664ba332a641a0"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "457a409edc57920c345a0550882c19f69669be5ae466dc43467b52e928fe0718"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bcec8ff1cc9a07f1f0b80a9c7762c3c138df025d022ec169b76515c643ddb2"
    sha256 cellar: :any_skip_relocation, monterey:      "1233740e5210db63fd353f26c259f39c36df1b854fd61f4cc6d96c85757f5c98"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7298c110f4b7aef93378fd18cf193ae3b25424598dd2855f0e62139c13af056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397ad409b6f098883082b68eff0b698048b3459baf562acd284e76b0e38374b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
