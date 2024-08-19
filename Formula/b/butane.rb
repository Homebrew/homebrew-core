class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "44c1ff13c01b4dd8ab8310fd4703c3e7ec411b15925cecb434ad5f595f9d17d6"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "570b9e8ef564d279566ee4741860f46f05d0f4a3fea1c3135379d3ddc041a8fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323077ac66cc7e737f43e0b270acbb753dfa498c0a6cf2a676035c591bf6c566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f18f4f7a0e7a4a25ae70f8b22cf0f6103bb4aaa19a7a1ee41c227cc9a4d9c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "face021d24a529596709f2b314d8b79ea884b06452f509ccfd7c45b4e31583b5"
    sha256 cellar: :any_skip_relocation, ventura:        "80132d87e55e6378b818e134d6b38012c0732ce5d912d4e8f27fe0fa9a511b50"
    sha256 cellar: :any_skip_relocation, monterey:       "fbdaf2e88ef5bd930e81ac464381ae0820916358b58157cca38f8eeec78fc54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc916a83969028e7b7b2d1714fd9e88ced52ad0fd5182534ce535fc653429f98"
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
