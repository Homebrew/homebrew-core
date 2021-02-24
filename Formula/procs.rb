class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.3.tar.gz"
  sha256 "bf56fde52d0f6544a2ca3db6d4552867e5cf9daf1c5a31f8b3ad6e3258986b0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3008bb790329683036c24cf85abe1088f6058db3a3eb54e033a42f24878df0aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "94ee0bcfdb8ff6a0aa12591593a8b70a0f77cc5a2b7159bd34d34b34bff92a61"
    sha256 cellar: :any_skip_relocation, catalina:      "74096d5074fa5171235dbeef0d8ba9c227f6da4128b9094e393651795bd20a8f"
    sha256 cellar: :any_skip_relocation, mojave:        "38eb93c5e9ecb2b684fee7bbc9c7e479f72df7e4799b202891a7158ae53ea02b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
