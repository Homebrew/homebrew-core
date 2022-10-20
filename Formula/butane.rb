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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ddf2f33d40903e17244f5ca95c986b163c0b36e9dd06406b679262222c09d21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dc165142edf5ebe293a96bc6173fe185ea35c734bbeda53ba0cb683282f8721"
    sha256 cellar: :any_skip_relocation, monterey:       "9451fd6d68e8aeffa29681208bdce36505ea3fe6ee280ecb54e661643fbb3ef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b4930099508447c0d6381184c9149892e56ce17aee21d42147abeffc76f4879"
    sha256 cellar: :any_skip_relocation, catalina:       "0384931dd47e46541e9fc516f1724b68cef69cfe43d7824f3fc466533b0ecae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25b9dfb516dc06d33e1cb3c64a308aad22d0e4e656dc3ea4f4f3791b97babefd"
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
