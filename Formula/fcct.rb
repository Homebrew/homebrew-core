class Fcct < Formula
  desc "Fedora CoreOS Config Transpiler"
  homepage "https://github.com/coreos/fcct"
  url "https://github.com/coreos/fcct/archive/v0.10.0.tar.gz"
  sha256 "4dc13da0a0473390e208ee303757dbc8c1cbeb1a9330199de86fa8f16afb24b4"
  license "Apache-2.0"
  head "https://github.com/coreos/fcct.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "168e14f5c7e7843342a66bd5073e198ee1f63c614b84803f9c9a83d6932b33c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad3be57c5b5be44baebf9b65b58707dc6ae42d8ec88694ecf212ef48b1ec6f71"
    sha256 cellar: :any_skip_relocation, catalina:      "bfa9271ef810cdaa856fe7f77a1bedebda49156a62ffedbadac2a7b3dff762ee"
    sha256 cellar: :any_skip_relocation, mojave:        "01a0424af0d9e118de1f247fee0c9b0cde198364860c818b55259e9c8884ae5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor",
      "-ldflags", "-w -X github.com/coreos/fcct/internal/version.Raw=#{version}",
      *std_go_args, "internal/main.go"

    prefix.install_metafiles
  end

  test do
    (testpath/"example.fcc").write <<~EOS
      variant: fcos
      version: 1.1.0
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS

    (testpath/"broken.fcc").write <<~EOS
      variant: fcos
      version: 1.1.0
      passwd:
        users:
          - name: core
            broken_authorized_keys:
              - ssh-rsa mykey
    EOS

    system "#{bin}/fcct", "--strict", "--output=#{testpath}/example.ign", "#{testpath}/example.fcc"
    assert_predicate testpath/"example.ign", :exist?
    assert_match /.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip

    output = shell_output("#{bin}/fcct --strict #{testpath}/example.fcc")
    assert_match /.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip

    shell_output("#{bin}/fcct --strict --output=#{testpath}/broken.ign #{testpath}/broken.fcc", 1)
    refute_predicate testpath/"broken.ign", :exist?

    assert_match version.to_s, shell_output("#{bin}/fcct --version 2>&1")
  end
end
