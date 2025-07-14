class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://github.com/evilsocket/legba/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "c5e0cf14d372792ac99d692894d407911106b97f1307494bfa68e791ef2273c7"
  license "AGPL-3.0-only"
  head "https://github.com/evilsocket/legba.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "546c0cfae3b2ccf6ad22072dd561490c38959ca611c7f76996d1001975f3a850"
    sha256 cellar: :any,                 arm64_sonoma:  "bc2703adb32f63f00a50f93485d62a8ca77139d44da4e01ef8f8601a2a31ac90"
    sha256 cellar: :any,                 arm64_ventura: "5f4c14f44040dfaeaa78911ce950bb7da785db6c7afee3c4a516c086ac55d01b"
    sha256 cellar: :any,                 sonoma:        "0e3680c1235811f38c02014ea3a0abb4fa444c31161469d0a3537beb3e944acc"
    sha256 cellar: :any,                 ventura:       "610f2288608058ded9a6b4386f9f50e5425773092be99faf12be6404e5e66458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06fd39a812020a3ab5eba5821365177050595d507a3ca81d49bf7b36b7aabee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b3fef8b4eef609096bf52bb3db2fa6361ddb683bedc357d34398b14b9a0a49"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"legba", "--generate-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end
