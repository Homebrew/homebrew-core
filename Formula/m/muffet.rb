class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "4271e365b47df8dc5f2219e904469bde7b8538aac672b75cbdd4e28648414c70"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f40036db9112be5e96b46835993d8f769221c62a85609f23add3899e3c4ce80b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de80c96115ffb8f57a272571f68bc31aafabc26759578d2479fad1f1c88fbeeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6303de219b6cdca2ca2b4bba5441550d147ed3708e8ed5a0b1b32e20a66180a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "016c5a9036e1c3f000bc97efe6d5c96bb052ef785a85f7d797aa9b41e06453d4"
    sha256 cellar: :any_skip_relocation, ventura:        "64b6c65dcc3fbf65d06674a9f416fcb8cfddb59295f7710bcd8ebcbe47047508"
    sha256 cellar: :any_skip_relocation, monterey:       "bb3eddfaa430de108390b9e6a68183ba582aa5774ef59d7ff59862c1868c407e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68afc3bcb1bddc170d8c2bfa036df447b52f6105548528433ec44936a0cd3f4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
