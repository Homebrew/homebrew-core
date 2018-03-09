class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.7.0.tar.gz"
  sha256 "8893181b937bc2319b10b0b52406f2ed156cad8081fe3ea2d44d7b72d811bfbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "a85155f35e946bdca5dc31ec98fc573a83111cbdabad115bb1d9f6df676f268d" => :high_sierra
    sha256 "76cd05d1f910df40b692177b8367dd45f7f6e67b05430c99abf320bba18f3521" => :sierra
    sha256 "aadeb730c66469ac823833658621eb89aafad14f481069e3a4af4c3f980d6452" => :el_capitan
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
