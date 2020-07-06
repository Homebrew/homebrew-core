class Fcct < Formula
  desc "Fedora CoreOS Config Transpiler"
  homepage "https://github.com/coreos/fcct"
  url "https://github.com/coreos/fcct/archive/v0.6.0.tar.gz"
  sha256 "2cd630f37fcd549e931df9a01f94f0f783e06463701b9f8b5ab9b293515f9915"
  license "Apache-2.0"
  head "https://github.com/coreos/fcct.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b525343e7d1401c4de2694c7ed25a40d05e607900519ce36c63e76166fde16b" => :catalina
    sha256 "6b968d4d747e4eb678ab899ff539e49ed771f5a0cc2f87a359e2e404b1e7f12b" => :mojave
    sha256 "bd2d80c315a29dba226b390329418701e2a149d50c4a16a5fad4a9083f26b433" => :high_sierra
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
