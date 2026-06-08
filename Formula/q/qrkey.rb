class Qrkey < Formula
  desc "Generate and recover QR codes from files for offline private key backup"
  homepage "https://github.com/Techwolf12/qrkey"
  url "https://github.com/Techwolf12/qrkey/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "7c1777245e44014d53046383a96c1ee02b3ac1a4b014725a61ae707a79b7e82d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "000b8efd1105c3c7ada0fcd77de138f093678fa63e05d0d34a7a7edaa31336aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000b8efd1105c3c7ada0fcd77de138f093678fa63e05d0d34a7a7edaa31336aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "000b8efd1105c3c7ada0fcd77de138f093678fa63e05d0d34a7a7edaa31336aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5f34e26dc4ce6f5d5550da929450890bfd239c7901ee84841b48c9e5c6bc7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "462db6ae6587e670d20a97470164005097e561aab011c95d0664ae62dbc81179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6ebcb2f32c7a3b58c487d805fcfdee662261822452ce937e78752a2d599f6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"qrkey", shell_parameter_format: :cobra)
  end

  test do
    system bin/"qrkey", "generate", "--in", test_fixtures("test.jpg"), "--out", "generated.pdf"
    assert_path_exists testpath/"generated.pdf"
  end
end
