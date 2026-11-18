class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "1cb6e90e5e0a1052a727e528ce292b24b0051b1b38665f31ccbdbf437593987b"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ab9fab5c40d6b6302d6f2f07ea914e5f096aad32265456f4756cd434c8c829b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28720d3c00dc9ac5b31f11e6bb3172e749807fccaad5d566568f314d57ffbbca"
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
