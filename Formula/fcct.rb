class Fcct < Formula
  desc "Fedora CoreOS Config Transpiler"
  homepage "https://github.com/coreos/fcct"
  url "https://github.com/coreos/fcct/archive/v0.8.0.tar.gz"
  sha256 "9938c84bcb39ab78e21f3632773f0840b4d6139ee10fcb567fb12a25447710e7"
  license "Apache-2.0"
  head "https://github.com/coreos/fcct.git"

  livecheck do
    url "https://github.com/coreos/fcct/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f525a4c997523b4f327914e1f1652b0f960da662197b2a5238f49088f2d5a49d" => :big_sur
    sha256 "80a3a8a30009c739ff99f2f5714f1bdcd09865fa9b12a41ab0e8013c59a6e285" => :catalina
    sha256 "e8c7b72902f0e5169afdbef0bd845337d0bca14082b0a4d75ab71e02b684dd55" => :mojave
    sha256 "45c64886c1ef514df45decbae073d7aa002ae45ca48cf5bb5fade20fee262e73" => :high_sierra
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
