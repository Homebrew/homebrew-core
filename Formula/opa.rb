class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.14.2.tar.gz"
  sha256 "b7b5a0874417a0ee0447a3839ecd97f4e25a5f02e7b025405fff7d12135a1bcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc79ab692800e9dce3037b27bc85c808af5f0db20f11f4d46902afa2e4bc214e" => :catalina
    sha256 "e699080ff1c42a510d6510c8a32215c08f54a680779e95ca7978df78fbdd0e47" => :mojave
    sha256 "0d0976414954cdb2cb8933ac4c48d5f872526b3d2fa8e7bcb2016f8c2a45afd1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/open-policy-agent/opa").install buildpath.children

    cd "src/github.com/open-policy-agent/opa" do
      system "go", "build", "-o", bin/"opa", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/open-policy-agent/opa/version.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
