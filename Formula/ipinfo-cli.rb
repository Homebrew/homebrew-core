class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-1.1.3.tar.gz"
  sha256 "04a5f6da5c5e52e184f8c8e90dd5af5bdb0bebd027ca59eb863b6f1f1bfd7a51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f27e301bf0e680fe12ad8e44be36e345c3edaee34f76ca31a842dc6852c505da"
    sha256 cellar: :any_skip_relocation, big_sur:       "b440bf6805db145f6c36b5a23415276bb852f6d73a2e0118eb14749257b05d1c"
    sha256 cellar: :any_skip_relocation, catalina:      "b7dd8f1405beb25da25e84f9d37950251edfa9d7df700dd3dcf27f38057ebf9e"
    sha256 cellar: :any_skip_relocation, mojave:        "e0021ff4d0089ae5e6d08c6a3682080b755df964dc45c9a0e81425949ac8d6ee"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
