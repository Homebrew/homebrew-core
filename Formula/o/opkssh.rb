class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "036287cf27ce2baa3715fe917e2d6b300a499ee8766c1895bfb708690162502c"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6385e6594a410713cae579bd55ab9bf74185a0ad1754c92cded7b651a5d52240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6385e6594a410713cae579bd55ab9bf74185a0ad1754c92cded7b651a5d52240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6385e6594a410713cae579bd55ab9bf74185a0ad1754c92cded7b651a5d52240"
    sha256 cellar: :any_skip_relocation, sonoma:        "22be6ff5f00177ee219b180dc32e78b1464198ebeee3da1099310ac445928490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b45a4e66d2111334a8e1c93c0c6001d999a9763a0d8f7906865fbb261efd8b"
    sha256 cellar: :any,                 x86_64_linux:  "5657cc38114e16f0d9969f0f687811d9a41fd446f0c2b70e2fa837098dee75d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
