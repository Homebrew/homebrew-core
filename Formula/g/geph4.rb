class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.28.tar.gz"
  sha256 "a06ba3a600e1a2956adf6f24bd4749ea630af0aaf5ee0c5295a5aeb105ce04c9"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c377652c9ad9fd810ebdc5380f52208e625f17ac309d730e82abd6990dbff6a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f79b07516a297946af9454388454f88d11a5ac9f4f40c85b0950968ae0c18c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a8cfc2400eeaa4705df40723341170e7d3b5ab3f6304e3981e7a966ca87fed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ead74d4213a31bc64919c9ba59aea232f20d654a5c331f36d75f63d2ce290f8"
    sha256 cellar: :any_skip_relocation, ventura:       "2173eddf4eb9eafd021653cfdce74fd58529d320826715c2bd55e54a625e167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccc16e2a1bffc6af3f42fbfb92f13974131f29fdc8b275ea5da2026183393cb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
