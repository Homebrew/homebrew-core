class Fcct < Formula
  desc "Fedora CoreOS Config Transpiler"
  homepage "https://github.com/coreos/fcct"
  url "https://github.com/coreos/fcct/archive/v0.6.0.tar.gz"
  sha256 "2cd630f37fcd549e931df9a01f94f0f783e06463701b9f8b5ab9b293515f9915"
  head "https://github.com/coreos/fcct.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b500067fe6d756f885caca1674610317b051c676dc1d84d8113577dd70219fc" => :catalina
    sha256 "e2bc7e8eed8a4644611fdb6434d22d868dbe3f2ec62233f4f9f310219e9cdcc7" => :mojave
    sha256 "9a5c29f52996817e56f2fee20bccb81d4ad3409b2fa3b9455f84e4394c8af289" => :high_sierra
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
