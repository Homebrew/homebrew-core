class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.8.0.tar.gz"
  sha256 "aaadace032628dfd2a298684168961920a5c8ebc6b98fd1b5f3683000fd35dcb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8e8e71e71be2250d7266afb8c81a1d635664993bd910b6f9cf3d8914af984489" => :high_sierra
    sha256 "210cdedc779768dcd304c2c1cd4817ed00c9702c334bfdff8771ee2a3d862226" => :sierra
    sha256 "e1bfc71d17ab1e545aaf8e6ca6565012ecd51b7851a5bdf2f9f0f3b538dde2af" => :el_capitan
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
