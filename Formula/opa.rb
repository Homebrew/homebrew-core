class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.14.2.tar.gz"
  sha256 "b7b5a0874417a0ee0447a3839ecd97f4e25a5f02e7b025405fff7d12135a1bcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "281fd49db2c5be80030bcfdabf3e23490b6354ce0a4d3e38f205c01421aad100" => :mojave
    sha256 "81d6dd4d60ae117b79228010a9df36217f818433c050a9baef9d3ed747c1a981" => :high_sierra
    sha256 "0bf442cd93b43f3ac52277b6c90bb426009242e7af799b53fb3d443ffbe1fe17" => :sierra
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
