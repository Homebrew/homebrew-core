class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.15.0.tar.gz"
  sha256 "b6098542ae11e0a75a84e0cb0e41139b16b41a6e75c52c76ceaae623be158dab"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b8dd55079242d7c6dbd3ff9c47d028d0919c82a67d6a54948f1aa790045da99" => :catalina
    sha256 "459878ca12c3793acc0f2d615a2d4e2a1e318f2f6d732d4a06b38fa13a648f6f" => :mojave
    sha256 "e12e9e44c0c481dc6ad35fd11e6c169b7e5b28c48b2c465e26e6602f89c1cee3" => :high_sierra
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
