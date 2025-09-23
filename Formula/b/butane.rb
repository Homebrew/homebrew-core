class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "ee73d5ae3fe4b422312302259b4e4938b217cb8cb23c48b3696840acfc711b28"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "743cf3f70ad159e47535a7bf3f5617961aa02a589aabd741fe1fcd124ce52194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743cf3f70ad159e47535a7bf3f5617961aa02a589aabd741fe1fcd124ce52194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743cf3f70ad159e47535a7bf3f5617961aa02a589aabd741fe1fcd124ce52194"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743cf3f70ad159e47535a7bf3f5617961aa02a589aabd741fe1fcd124ce52194"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d475b6a57be572ed42f7d61b11c93d3931153592211e1daa8d5ecd3a35eb1b4"
    sha256 cellar: :any_skip_relocation, ventura:       "9d475b6a57be572ed42f7d61b11c93d3931153592211e1daa8d5ecd3a35eb1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c730e4d829498e0fe62fd0e9f683daf96ed42faff390d1e9041e7b5ce1c0e6b"
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
