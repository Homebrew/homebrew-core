class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://coreos.github.io/butane/"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ae3a4731bc7da29177936a229a962c701249debdf740e10c08c152ff725ad2f7"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f771dfc7e1104ff265639120ab9200154c8b6ca1e8be3685f9047535f756d426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f771dfc7e1104ff265639120ab9200154c8b6ca1e8be3685f9047535f756d426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f771dfc7e1104ff265639120ab9200154c8b6ca1e8be3685f9047535f756d426"
    sha256 cellar: :any_skip_relocation, sonoma:        "0722708c1add344707e4ea18a5e7f3d160714833b3f51917f967c56d45f24401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195178ccfe60813b75c1ca9d7a8f78ff6a03c451295dcd3ae0b8f41f7a1eaa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40600aba821c7bd340a5bea95aac31a31a85617b8f9ba22d496692d911fa72d2"
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
