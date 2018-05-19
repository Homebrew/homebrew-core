class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.9.0.tar.gz"
  sha256 "140c2a5bfd2562a069882e66c4aee01290417f35ef0db06e11e74b2ccf52de7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8b2f678aca517399804f76bc6a276f821328f46936e1db11eac1c60f58317b2" => :high_sierra
    sha256 "00c96cccd0cf7d829bb9094d6cbe015a964784ff86d2a3ed8fad5dbe074ac8ee" => :sierra
    sha256 "c2d25c2e3f43961720dc16e4bf501f05914e7a6bf3b8061073f567a2a7652acc" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "make", "all", "VERSION=v#{version}"
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
