class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://coreos.github.io/butane/"
  url "https://github.com/coreos/ignition/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "a2ff1a2aafc1a54fedd535487c4b0cf2afad5945a788edfb85140420a1f772de"
  license "Apache-2.0"
  head "https://github.com/coreos/ignition.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fa01310a34c27563015629b237b79be4ae16150149779d2605bd09346f03950"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fa01310a34c27563015629b237b79be4ae16150149779d2605bd09346f03950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fa01310a34c27563015629b237b79be4ae16150149779d2605bd09346f03950"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6d41c21df5b794b7e7f8a097f0977ceaf64049a9416168f98eb575bdbfb3936"
    sha256 cellar: :any,                 x86_64_linux:      "991c898d2691bfb062728e420231fb523fa4593dcfef4767c120b0ef2a3f2dbf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/coreos/ignition/v2/butane/internal/version.Raw=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./butane/internal"
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
