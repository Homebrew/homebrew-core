class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://coreos.github.io/butane/"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "fb53732f08479a8057f60e7d7535e3717ecd013e362d65f474272b44374e0f97"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0549fb450694816c1f3fcecca3d00127d92253719b540042aeb11ee283135f3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0549fb450694816c1f3fcecca3d00127d92253719b540042aeb11ee283135f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0549fb450694816c1f3fcecca3d00127d92253719b540042aeb11ee283135f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "89790f467b35bc6555229963bd47490681916a8a7e1345031c2edd30bb0957c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f55259e0be9b61d2b2aeaea83e4a41505fffadeb111e51e3f735e65a8938011a"
    sha256 cellar: :any,                 x86_64_linux:  "de5d57fe6a501ebb9a1f28d01d718f2bc0d5bc94c527c1e37caba3f6ca808e9b"
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
