class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "4294b92ab18cecfad3758100017d4fa3af6da131b3ae1ce1074c5c0e836fa9bd"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b5aa550fa53a4b56cd6f8ef44bcab381c5c60e1d2ec8396d3b10b24d78babe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b5aa550fa53a4b56cd6f8ef44bcab381c5c60e1d2ec8396d3b10b24d78babe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b5aa550fa53a4b56cd6f8ef44bcab381c5c60e1d2ec8396d3b10b24d78babe"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bed8a4d10dde908c0687e707f80e8a66484dd0475d1e00a7a9a7fef310fbd2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ba8f3b92dcc0c8277bdc06befd4348fb6dec7825ca792afbc4314c594813c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4beb755a0353cd54e9865684e17f615792d7013b6605601e575040bbde39e04f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor",
      *std_go_args(ldflags: "-w -X github.com/coreos/butane/internal/version.Raw=#{version}"), "internal/main.go"
  end

  test do
    (testpath/"example.bu").write <<~EOS
      variant: fcos
      version: 1.3.0
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS

    (testpath/"broken.bu").write <<~EOS
      variant: fcos
      version: 1.3.0
      passwd:
        users:
          - name: core
            broken_authorized_keys:
              - ssh-rsa mykey
    EOS

    system bin/"butane", "--strict", "--output=#{testpath}/example.ign", testpath/"example.bu"
    assert_path_exists testpath/"example.ign"
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_path_exists testpath/"broken.ign"

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
