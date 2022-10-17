class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.16.0.tar.gz"
  sha256 "ea6e8bc51bb2f00559c4392fa0e47758a6e84884a6a7b15980dcd3bf53c95b03"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d1367de5b37f73ab7b496ddf91849d1b77e657a3ecdc15288c2c41a528f204"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4af25898c5516c9082066d32d9f3997740ab47c6569f4745bd862d0ca4acb218"
    sha256 cellar: :any_skip_relocation, monterey:       "22554a73479c6a92d9e56be5e37a52c8bb12964c3d073715807764445e3c1e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "0259236e76312514a0531cc80e496826a95ae48c0fa4225e8f987e272bf42f4f"
    sha256 cellar: :any_skip_relocation, catalina:       "e8104d8c91febf277c0305809cbaa251ad37e8053d6117968a6873f3f4ed609c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c57ac4021187229738f0168b964acad5bc163e527cc51bc296280e2d0b3ac44"
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
