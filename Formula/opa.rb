class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.15.1.tar.gz"
  sha256 "b51fd9ba0d99d084c01ceace50cd31b900a12f61dd9d6c6fb5ce7f026a8556b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "37d22a6a5edbb5ed64ce8bd154f284a872c6b8cafe4becb64b6cfcfd824879f1" => :catalina
    sha256 "2b27039e065eb1f89b6dac2fc2a57506d7c069c72d3d04daf41f02d6907669f2" => :mojave
    sha256 "57651d6c3244f6eb86696da89b9c64737e6e0c4ddee8616bf71d262feb4d42d2" => :high_sierra
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
