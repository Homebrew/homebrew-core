class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://flatcar-linux.org/docs/latest/provisioning/config-transpiler/"
  url "https://github.com/flatcar/container-linux-config-transpiler/archive/v0.9.4.tar.gz"
  sha256 "c173ced842a6d178000f9bf01b26e9a8c296b1256ab713834f18d3f0883c4263"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a0e3189ec955041eb885241c04183bedc694f19ff2382aca9a7b80424e1b3d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daecb2d366f73487e19a3357e64fe02be095ba9a92ac8d6ed4350d3281d5f9dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ee0a8cdf60e4f9ceefbb28529c508ff16cc8dcc8e6b9d3ea3ab2c5bf05e8a6"
    sha256 cellar: :any_skip_relocation, ventura:        "5b29ea3c72c04112fe9d88b6f9253ee6853289b0a697f9468f0bf747d92cb977"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b7543e14bd73c528cbfca81b32f56c18d17018ef4e7edf7d16870223eaaee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9517910a97a3643010e7d0ccc65dab68a6e85a7321780a0d3e095686530b6502"
    sha256 cellar: :any_skip_relocation, catalina:       "acb5592eabf664da5576e643378d903d9c30b3ed57c2ecaba8b0d48c8f561041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf7582f950db123c1c3e6281ca2947c95abe58b116af11681a24085d1eb1e82"
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
    output = shell_output("#{bin}/ct -pretty -in-file #{testpath}/input").lines.map(&:strip).join
    assert_match(/.*"sshAuthorizedKeys":\s*\["ssh-rsa mykey"\s*\].*/m, output.strip)
  end
end
