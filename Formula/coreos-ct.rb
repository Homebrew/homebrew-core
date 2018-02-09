class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.6.1.tar.gz"
  sha256 "57cafa9db08caa6bed0290612bebf5d1a763a96fdb21f23de1681fd266b0c3c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "54ec2fd538b38fc7a5a7c52c775626495db04d8a259ad8f40d842187d94976ff" => :high_sierra
    sha256 "327e8e1962923dbbab4d05b8d112112ddb1f5586660cd2cc290d9a46c0a3f27d" => :sierra
    sha256 "05902d5c2cdeb6b67c5a88f664f2aca4ff6763ddc339774a4abba3df15d4fe68" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install "./bin/ct"
  end

  test do
    (testpath/"input").write <<~EOS
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS
    output = shell_output("#{bin}/ct -pretty -in-file #{testpath}/input")
    assert_match /.*"sshAuthorizedKeys":\s*["ssh-rsa mykey"\s*].*/m, output.strip
  end
end
