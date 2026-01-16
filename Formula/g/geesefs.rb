class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "ceaeadbe3f670f3ba01563682848decb0c2719ec3a0a65230f79cdb1383c8607"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33c7f1346ca2e91a98a7165aeb2ba32762951c3f238afcae00b3ff3b6890bfe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b9ea2048973c022391fb30030679b9c31a1a060b4e36f2062f54ab8a1290ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab2454e6a4922c0895f3e21a0a71a2b03ae99af2523dd19bb50edc41dca512d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00f1452a77d54b9d0d93858647e842215cd966ab33ecbe409a4c0e57391c5348"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0403d1002b44d5e0ced58591c9cde5674a2173460606ddede503f38583c573a"
    sha256 cellar: :any_skip_relocation, ventura:       "ffe0e0e81381b7f5120c27b6ebb0b1ca1878d4738d3c743df2467e1d88691a52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1558bec218027ca5eb65f2cd2e946472dfafd5b5b8cb2b2c692c571415cad79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0c669bff9ff76321e43e7fd086745ae7710259c25c7a3364224f6aa190ba6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    output = shell_output("#{bin}/geesefs test test 2>&1", 1)
    assert_match "FATAL Mounting file system: Unable to access 'test'", output
  end
end
