class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.19.0.tar.gz"
  sha256 "62a7e8a34168f041091eb190dd3d9f3f7f5c122cab81deda53c0bd49ca99eeab"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f563396f90d2946c9d71d7c40a36d6c96b7ea5e6a88ea4c96fae4f927f59acd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf60edace69dd58fcdbdc305ae9d8417f656f69a8152c794e7c9f5091642a967"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "624c6446d83eddab2f2e9315955294f8e890acef5684c75de284e9e05fc4c839"
    sha256 cellar: :any_skip_relocation, sonoma:         "752631c728661f29ec11138f0d2fa9ee0b3d73a0039d90bd72a5bc53dedcfa87"
    sha256 cellar: :any_skip_relocation, ventura:        "967e21d78baa4935d456a802489f14e0f216541eccce3f3ff4193096199767d7"
    sha256 cellar: :any_skip_relocation, monterey:       "8a57993f352c007bfec51de97600dd970aac4d0a34163d3be938c7cc8c2b3854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "976a04027755e60b6179610e780cf441072164cfa9eaad6cdb776540cf22fb0c"
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
