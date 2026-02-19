class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7b0180c8bda0df15c627a99a105e41f76d421c19a8f7f8f256da7eb2fec991b5"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a43e1383a77a301720e1ec28afc701d701c64ee4bd2fcf59fcf5a3b6c8d665aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43e1383a77a301720e1ec28afc701d701c64ee4bd2fcf59fcf5a3b6c8d665aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43e1383a77a301720e1ec28afc701d701c64ee4bd2fcf59fcf5a3b6c8d665aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f3f2fd6232596799d4da2f93ac34faf9afb04cd75adb0140d83aa5cf10dbce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c372830f1d4187c754ef016e740f767829f5aef3d2597f68939d790980d24219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bfc92e40fcdf687c0a7bb28b654900c81a598c6e263014c34b785cc69d92475"
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
