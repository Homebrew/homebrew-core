class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.2.tar.gz"
  sha256 "862ed0f6b9a50d3c0a4865ddba2a2bfc451854a5597c0ce477479f0d203286ce"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "dc887235730f2fb1abc317bc8e8654628427d27d420bbbe9f497f9a174ece075"
    sha256 cellar: :any, arm64_sequoia: "ee9218aa29bcd0a582212bdb199febd89ca86230ed4e2cec99a7f2bc47f1db6b"
    sha256 cellar: :any, arm64_sonoma:  "51791f02d36dd52fac564e5df39bcd315aa965b282549a2b60c7498c45793fa2"
    sha256 cellar: :any, sonoma:        "6275ad7a60f454934413d608bd5865a5e838541cda618a9e0bd0f82bd7e8da13"
    sha256 cellar: :any, arm64_linux:   "fb21baa9672b03b0d5c853fc0581965cf14ecfc1d82fcc1e76224ca9b4613444"
    sha256 cellar: :any, x86_64_linux:  "715413c5cb897a481a584e7525aa020e8d6b3f0c5fb056666b3a87bb1515595a"
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
