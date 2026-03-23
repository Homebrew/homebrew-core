class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "ade96285323d42ae8a1df4ce6709757adb6c445248bafe3314971737a7252e62"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ce36669f9ff8b5a3491edaf3eefd6ef1bba610e8c151492a2a5d21dad69e1fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d332484a0c7ea562d0d326ecb783fd3ae8c04772ee87d83be14e1c4679f01f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8db8c5ddb898128dfcf332c46a1917d7d6e9bc6589a3d86221f9c2a4e6e139"
    sha256 cellar: :any_skip_relocation, sonoma:        "318206c93889907f0b95f0a7641d7d6e534210cfa41fe33450324754da47385d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c4772d25db1617af1234f1131a15c80900e67b1116e7672b5c9f2b3dce80722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c11879001dc65a282d19e8ad78ab53e76dc89f82dcc6cf6c10ef3057e4907a2"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
