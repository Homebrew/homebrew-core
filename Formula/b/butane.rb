class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "1a91ea42a7d952fd91078c7492e8f813e0e69d312225ee1903c157024da7e643"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7761c658646399a2c13e657ba181a8002dd083ceb49be5be6c109b67fd3cddf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7761c658646399a2c13e657ba181a8002dd083ceb49be5be6c109b67fd3cddf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7761c658646399a2c13e657ba181a8002dd083ceb49be5be6c109b67fd3cddf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86a1faf586ac1e7252e06b70d875e5174419ca74b88926b903c28d1f48ede9b"
    sha256 cellar: :any_skip_relocation, ventura:       "f86a1faf586ac1e7252e06b70d875e5174419ca74b88926b903c28d1f48ede9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3aa4a8ee4f2d41e27334ee2ece8853a321dad4c52d8189e1120c093559df52c"
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

    system bin/"butane", "--strict", "--output=#{testpath}/example.ign", "#{testpath}/example.bu"
    assert_predicate testpath/"example.ign", :exist?
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_predicate testpath/"broken.ign", :exist?

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
