class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.0.0",
      revision: "ce2f5a367a1495897a1c486ebfa7aa6d49175732"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f22669ea9f94134ef52397722cdd8b37ff6f95515bdb1d5240f0d13a1d38424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a40dc00d8e4db3685b05ebcc2a88350111a1ded8acda10ac64360ca0d538a872"
    sha256 cellar: :any_skip_relocation, monterey:       "e0fd331d0f743196f8eb8dbe3c777dfa2ab8fadbc8bcc27587a9f100345b2b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2f300032eb4f5b833e191df4c81b6fc75e888400a56ae2a6232c80ebdf01b84"
    sha256 cellar: :any_skip_relocation, catalina:       "6217549ee84e5fcf8938daf56a01c7e9bb4623266943884585dca071598b9e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d77c0b822dcc19e4e7f82bd41033a14f71a41d24389bfde3b840eb60cf5466"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
