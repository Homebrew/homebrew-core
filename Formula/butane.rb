class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.12.1.tar.gz"
  sha256 "6f2967009511361ed22cabb1de18ae2a3317537925b3b33b5bfcee363a77d062"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0b0fedb580b6eb107172bb425b3de3a3ced9f6e2d68d206a80e3cd9ae63c2fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee6687d81be057506a3e5820319c95451aa577a92a5ba28d0f2008812610336a"
    sha256 cellar: :any_skip_relocation, catalina:      "8478d8cb15794328cdfbb4385a2aa809256205f243d7baf77bb1bfebcbbc7e10"
    sha256 cellar: :any_skip_relocation, mojave:        "6fc9ad566d96eebbac7539661e986aa0078d6aff8a417eec1bfb4722f7361058"
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
