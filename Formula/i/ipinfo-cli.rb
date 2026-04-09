class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.1.tar.gz"
  sha256 "b3acdfdfdebe64b34c7a1aa80de25fd7178a51105e588ad0d205870ca9d15cfb"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629bce3608145a3bad1850c24b09617d223f4307e432b256cafb35a7f1d68bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f5aa2b1f8995258d1afa217a73e990cd054775b09fe062d3e663dd8aa03c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004f55184d0983e4ba071aa51c46eb7f2b421cbb424b88b9a315683aba9e6b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "3909846e5be7d305fd8b3861957c719fee0a1490950f57bcb499ac6d5e4031da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239dcc822e7759a8ae57a8df5bf91218e6ab59b5789e64b93bf5be59451e4be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d357ca2a3418da8d4f16edeca092f2e10a9e30ccd71992f5aeaf5d320773c0c"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
    generate_completions_from_executable(bin/"ipinfo", shell_parameter_format: :cobra)
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
