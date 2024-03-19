class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "cde5ecd3a535b7dba81056cadd5985288fcdfcef4544d5610322d95863f4a40b"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acb1c3dc58d6b1e9197723fd70bab260e7f86c890f2b126099b02cdaa2ffce3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d97885dda04b095371f8048eb4932ac5208d0c53080274643ef08e5a1819f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7ee8049d27f3840967b4410612ad1428e5c7beda32808897cf26cbba690f8bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "b22da92491c8716746d836f87b3e4d4400f75f699a46415c90d17a87b801c821"
    sha256 cellar: :any_skip_relocation, ventura:        "a3700c75d80ad8db326c29b6ae3dc859be7fe02e2330636af72c5d82a60110b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f7fde2ea0300dcee3df7f00c2e62f7ec6b65fd6b28e1638f63a9a1d2604c62ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4da61e292a1bb53f3163ceb00494c442927596ad257161a4edfb4b184a0a381"
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

    system "#{bin}/butane", "--strict", "--output=#{testpath}/example.ign", "#{testpath}/example.bu"
    assert_predicate testpath/"example.ign", :exist?
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_predicate testpath/"broken.ign", :exist?

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
