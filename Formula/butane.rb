class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.14.0.tar.gz"
  sha256 "b6328c6186a7f5ddd1337bd75650db5d19f32ab1090f9f9e8893f1acca259a5e"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6283322b4afd8c56cd6b3fd866205ce6c30f4f40c31a4b1b15f8c0a31701bfc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19fc49d96b6c42a5c5c67ac62cd4ef036b96c52325eafc4d86b7fb8f75cc777f"
    sha256 cellar: :any_skip_relocation, monterey:       "44a61e029ddb03358657be0a32fe7cfc4ee7a61123a1246a994b3517f9e4668a"
    sha256 cellar: :any_skip_relocation, big_sur:        "64fd09f996c130168cfe5486948de57c175d030579ae3d03c5c138c451e3e17f"
    sha256 cellar: :any_skip_relocation, catalina:       "4e03586e27350f77d63e9796baf84a13c3084c6a026d3db220092a40a3dd9b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2af339ce31bf69bf36dd6c9bd029badc95e615649d9ac5074a8c5f63b371147"
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
