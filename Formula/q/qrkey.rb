class Qrkey < Formula
  desc "Generate and recover QR codes from files for offline private key backup"
  homepage "https://github.com/Techwolf12/qrkey"
  url "https://github.com/Techwolf12/qrkey/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "7c1777245e44014d53046383a96c1ee02b3ac1a4b014725a61ae707a79b7e82d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"qrkey", "completion")
  end

  test do
    system bin/"qrkey", "generate", "--in", test_fixtures("test.jpg"), "--out", "generated.pdf"
    assert_path_exists testpath/"generated.pdf"
  end
end
