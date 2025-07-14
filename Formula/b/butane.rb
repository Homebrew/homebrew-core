class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "57724f027b76074801ca988b6859738085643c50bec44c2672e64a7047f6fb95"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cce41cb8d792fca5cb8fbb287ca3db628ecbed2656a432daf61bda6b7aa4b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cce41cb8d792fca5cb8fbb287ca3db628ecbed2656a432daf61bda6b7aa4b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cce41cb8d792fca5cb8fbb287ca3db628ecbed2656a432daf61bda6b7aa4b26"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e4edb2877ff7ce99f709ac4451fc4d756d421bb37d31c3e2df9460d5028e418"
    sha256 cellar: :any_skip_relocation, ventura:       "7e4edb2877ff7ce99f709ac4451fc4d756d421bb37d31c3e2df9460d5028e418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933138ba8a1713f572e1e11c90f8d0f0a209f8d2b5aebe6408fca11df204371d"
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
