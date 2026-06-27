class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "8505d8dc0bacd13cef65f1f17c90e11a762e745dcd5f51a85bc4d2ada810715b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f53f048b8032b0c131746e445fd4c896a65e5aae465e7b084a71a79a82cebe38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5abb9e5a43f538983f27343f23e0ed1871abc7a2e7a1f2ac3c6c365d89c1384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16b44d4ebdd5bba2a59fcc869c82138465dfefd8059ce3ded727dd0cebf3be7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f82b973048c8f4b0f3b3c724a251f72269debbe48122154cfd32c110b63058d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80b326c45a7233857d739be2a63869e098b78a048a8c9e6a65a80fc544a44d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab608fbae7c8ed1b01104fe4e95d8035c815a751e299355d9af19492b6c35225"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  # Fix compilation error on macOS
  # PR ref: https://github.com/timvisee/prs/pull/46
  patch do
    url "https://github.com/timvisee/prs/commit/dd29c60992714a160e88c32f6ec8848e7ccbee12.patch?full_index=1"
    sha256 "51ce3804136dc7712e7c2d6c434d68d7ab10885f16b0d79f7549f2c99d9d45a4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"
    expected = <<~EOS
      Now generate and add a new recipient key for yourself:
          prs recipients generate

    EOS

    assert_equal expected, shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_equal "prs #{version}\n", shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
