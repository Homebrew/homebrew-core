class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.6.1.tar.gz"
  sha256 "57cafa9db08caa6bed0290612bebf5d1a763a96fdb21f23de1681fd266b0c3c3"

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install "./bin/ct"
  end

  test do
    # assert_equal "ct ", shell_output("#{bin}/ct -version").chomp

    (testpath/"input").write <<~EOS
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
      EOS
    assert_equal test_output.strip, shell_output("#{bin}/ct -pretty -in-file #{testpath}/input").strip
  end

  def test_output; <<~EOS
    {
      "ignition": {
        "config": {},
        "timeouts": {},
        "version": "2.1.0"
      },
      "networkd": {},
      "passwd": {
        "users": [
          {
            "name": "core",
            "sshAuthorizedKeys": [
              "ssh-rsa mykey"
            ]
          }
        ]
      },
      "storage": {},
      "systemd": {}
    }
    EOS
  end
end
