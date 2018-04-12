class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.8.0.tar.gz"
  sha256 "aaadace032628dfd2a298684168961920a5c8ebc6b98fd1b5f3683000fd35dcb"

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
