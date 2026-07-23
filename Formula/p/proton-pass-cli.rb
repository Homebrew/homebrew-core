class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.3.tar.gz"
  sha256 "b822b230b687ca600b599fa635e004180cade43c0b17767c281738f0571efb3c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "becf8a6b5a39c918bbbd31a11b880d4801895e9c57df65a5311f4f7a87cca207"
    sha256 cellar: :any, arm64_sequoia: "0585d35801c9fc89c255b041db5637c5b82d24c030524fd4754437e33c05d11d"
    sha256 cellar: :any, arm64_sonoma:  "dc138ba25ae0104585a55c40b3fb2a40ee93b666970b9c79d3cddb2c11543f32"
    sha256 cellar: :any, sonoma:        "355e03c64d7e10c11452cb5df1c21fc2ccea0bf9048132bfc5288a790a9415c1"
    sha256 cellar: :any, arm64_linux:   "7dcb6f13304bb1c9da8d28e5600536a6af42a5efcae2ac3ec5969e9c3c212cf7"
    sha256 cellar: :any, x86_64_linux:  "b50a18cbe92e060584f85302b152f3eee3741633d74b12d5ce8c8fcba734b7ba"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
