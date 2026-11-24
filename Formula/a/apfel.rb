class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "0708e93e35a6617424cc2b49d7f7f518dd33a87312c25db49bfc7dd5f5aa6180"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "faba65cff265b63760e170521dec80cf9eb2bafe292e888e5f4aa073056dc251"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "241c3a3995785e30739fa60fd5dd251a256040004e43bfc8b8a1366df5f10580"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d5c3f66a830c0a40545ad93db2f2c5325e9b5eec20273c30e1da4f74a0095f3"
  end

  depends_on xcode: ["26.4", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/apfel"
  end

  service do
    run [opt_bin/"apfel", "--serve"]
    keep_alive true
    working_dir var
    log_path var/"log/apfel.log"
    error_log_path var/"log/apfel.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apfel --version")
    shell_output("#{bin}/apfel --no-color --model-info")
  end
end
