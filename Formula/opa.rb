class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.13.2.tar.gz"
  sha256 "461f095a98485d21c437817f38c6d8b0058bba1c502046f689fab45c728e4fbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1f348eb8bcd86d5f1e5517828e6e7aaabe39c537dd115706e3164499b9288b0" => :mojave
    sha256 "3e2bae4ef18d27f9c11a8340a85a425212f9ee64d0fae23fa37dd186f562db1e" => :high_sierra
    sha256 "f50594aa84a9ed118a76a2cdfbd4622d7789d36323882099efc33cf07fe8886b" => :sierra
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
