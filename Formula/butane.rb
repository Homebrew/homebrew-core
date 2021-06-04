class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.11.0.tar.gz"
  sha256 "3da1138aa86dc069e6f08b7fa9a4f3b910593406a0cc48f71edc7b3e1d1b1c49"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e6ae4008af9fb8dda9996a611a89933c070ea957cb82238238b93169ebc89c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "b48f545690f7676ce59117fe3fec9c3a89872241c788081c1e828a62d5e93195"
    sha256 cellar: :any_skip_relocation, catalina:      "9a412c89813d6f51a694557d4b38b849e3133af9b2707b4a77f648ab3b7bb32d"
    sha256 cellar: :any_skip_relocation, mojave:        "bfceadc7c496f1d78b65f725ae01572eefdd74e6b8080b539c285033fffbcbf8"
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
