class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "508509be98959175d0ac7a6d7734be94880f0d8e1f59d9e69ca4a474afc2d0b4"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb70a899f9fa495ed3ff6a99c4c099b345c17b3b52d8a25f8a2baf92ab6cba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f20b6df759ad0541ceb14a03598c0346e5e74eaf10cf2e9abc842ae9ddd9b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b614cd0f13923def7ce1bb9d1dbdc58099c21954f7d328c72ef18151e1974736"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab910e65324f3718a7362cfd29a29e10b16fd56e476f66cd7c22ad704b20096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37e5208619b47c711f05bfc2712f65b7bad0fa8ea40643af9f8152145e5c2e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c2c89d9d12b16160cb73f36c6e3ba664b9c905abc833c2635802b216261f7b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
