class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "f47c15f605736aaeee20fab290a4f727c8296e4c514ca2d18c0d938ad6c1960d"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b67439526a0cb6bf11b8229ba2f897823e5743d2608ce2aa180279cb806b636f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b67439526a0cb6bf11b8229ba2f897823e5743d2608ce2aa180279cb806b636f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b67439526a0cb6bf11b8229ba2f897823e5743d2608ce2aa180279cb806b636f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2629f827357fa868400dd45037a9ef92aeca40c8b2f160916e2aa44175cb9c53"
    sha256 cellar: :any_skip_relocation, ventura:       "2629f827357fa868400dd45037a9ef92aeca40c8b2f160916e2aa44175cb9c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a63ec4b5ece62c1a27435f06232ebf6e6c118dec2e6ea96fbbaf5d7625e877"
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
