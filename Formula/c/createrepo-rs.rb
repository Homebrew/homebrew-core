class CreaterepoRs < Formula
  desc "Pure Rust RPM repository metadata generator — dnf/yum-compatible, zero FFI"
  homepage "https://github.com/jamesarch/createrepo_rs"
  url "https://github.com/jamesarch/createrepo_rs/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "9f93784bf1d9504827c17009288f1f122e81a5975e651102405e0985be401f14"
  license "GPL-2.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/createrepo_rs --version 2>&1")
    assert_match "createrepo_rs", output
  end
end
