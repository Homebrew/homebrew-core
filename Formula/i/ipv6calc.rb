class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.3.0.tar.gz"
  sha256 "0255b811b09ddbfb4afdffe639b5eb91406a67134def5230d2c53ac80f8f4dd0"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1ee095ca6ad409d22a619adfdc84e0d40f129f1ded51d383fb96c1e5c7c264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4a707eb3df85445eeed0e2207a8ff6fbcb5f52f5d555ce96d2bd4961072f885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e972c4a4e8ef9b74f037fae1a8f680a8d538bd4346833aada50510eadb2edde9"
    sha256 cellar: :any_skip_relocation, sonoma:        "72e53c7d306ea9905a00017c1432add44a8745edd47ea423003e4ba8691e3851"
    sha256 cellar: :any_skip_relocation, ventura:       "2d444dbeef51958c07a302782451deb9c14086f8d858e2f66adb95235464c8b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef806d99ae229bb9c228dcaf6d69e3991b40bb9cfa9f40b3e1c01b91151974d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ac597e58e860837e7db2fa2afc9f0a77260e613438b8fc37301f1f8643ef3f"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
