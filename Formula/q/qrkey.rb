class Qrkey < Formula
  desc "Generate and recover QR codes from files for offline private key backup"
  homepage "https://github.com/Techwolf12/qrkey"
  url "https://github.com/Techwolf12/qrkey/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "7c1777245e44014d53046383a96c1ee02b3ac1a4b014725a61ae707a79b7e82d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e5a04be8111567d2c19eb01cb0fd762ddd6056c47bfe78bcf3679d1f738b899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0fc3c4115102c6544d9f753c2e16dba1533314099ff50385b7442689b378a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0fc3c4115102c6544d9f753c2e16dba1533314099ff50385b7442689b378a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0fc3c4115102c6544d9f753c2e16dba1533314099ff50385b7442689b378a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9d690e34e9d67f33134a59820b1c3d7936cf0c8b33e0f0297c58b0c7a25520"
    sha256 cellar: :any_skip_relocation, ventura:       "7d9d690e34e9d67f33134a59820b1c3d7936cf0c8b33e0f0297c58b0c7a25520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa36d7f2c17914c7c27abb0854d381500385630ca14a0167df6042f7ddae198d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d151a47fbbc11d37a7e9613ecd6d9e0427ac8a54134cdd74e18d32f69b2dba9e"
  end

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
