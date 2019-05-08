class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.10.6.tar.gz"
  sha256 "ad757f2eee14e7262335967fd58a96a900677575a67240332d271f33b6e36b85"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a9cddb682d94532d8adbf23e1359d8d60288c3a7fe11c2e21a81a65028fe8d6" => :mojave
    sha256 "1898624cc87c832b6f04e9ecc6a13f22f6ddc1cc5a21a712aef0a47cfe267a88" => :high_sierra
    sha256 "d018c5ec4c53c8262f909eb055a18802ce60335bf58a598f8e1250148aa44c79" => :sierra
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
