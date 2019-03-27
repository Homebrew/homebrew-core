class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.10.6.tar.gz"
  sha256 "ad757f2eee14e7262335967fd58a96a900677575a67240332d271f33b6e36b85"

  bottle do
    cellar :any_skip_relocation
    sha256 "b833cffa7721b8b3a38f7775eb304de2efe34ab183d34aa92c05f45015a80c5d" => :mojave
    sha256 "60259f0e22fbf47a0d7e0b512af9286fa0da74a062473836e4253164e564976b" => :high_sierra
    sha256 "2b7f64e42f8ff2d368ff37b56ef05350286d71b40ae4208df5cf826d6a018b64" => :sierra
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
