class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.0.tar.gz"
  sha256 "cde6fc3199e4428797fdb22c0254c1d6bffc324bdff188db514fae460494b7c0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a3657f3fe547e73d7552cf79c63eb1f1c4625958ff09c2e2421e8b65005a41e"
    sha256 cellar: :any, arm64_sequoia: "b89aec9a0c3720e038ce57c40cb84c4c1866aad9384aebb3c1ae8c9724b366f9"
    sha256 cellar: :any, arm64_sonoma:  "f16ee29bd0276b502a863d81660cc194bc63728a13b44ebcc1add2bab2e3a7cd"
    sha256 cellar: :any, sonoma:        "584253c64aa9040666a5b6066af85f190a5bd12f54c2887a48a2bbe64c8c0cb4"
    sha256 cellar: :any, arm64_linux:   "e60e6aea869c1a67658cd677a6fa9fc504ced9212041ac702118ba94b11912d2"
    sha256 cellar: :any, x86_64_linux:  "e3ccdc4599d20108e289736124807ae7bcfc22425f541a7fdebd02cabf4d27f5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    assert_match "Error", shell_output("#{bin}/pass-cli login 2>&1", 1)
  end
end
