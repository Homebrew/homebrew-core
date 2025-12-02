class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "14203e7fa13f5753e332c472d0d7be3fc7ddf9a637873463793d898bb61cf69c"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "462e8be7b0aa75adecb7309207b6820cc18ca2991159e8bf3e79f8a14c5d4f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462e8be7b0aa75adecb7309207b6820cc18ca2991159e8bf3e79f8a14c5d4f93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462e8be7b0aa75adecb7309207b6820cc18ca2991159e8bf3e79f8a14c5d4f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c227b7f81ac0f40e7be5a2d263ddb1825a87c5ebbe552033abdd1cbcf6423e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc15c74454f7db160bfb6801d1ddab0d043cff9152245aeaeb7e9a518c64deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9791d51417e488f5aa4e00a60d95b46412f29f02e686ba4c7787ceee56af5aeb"
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
    assert_path_exists testpath/"example.ign"
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_path_exists testpath/"broken.ign"

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
