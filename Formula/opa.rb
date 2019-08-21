class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.13.3.tar.gz"
  sha256 "1288c2687b5b8fd106dca78df96be7b022322b3465a384a0c7545748969cdd5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "104736bbd3ec8ef9d50f50c5808923fb1e96a563a82972d2879989c888ade233" => :mojave
    sha256 "1f4f2064d85f4c1ecf35291aba1b706cdf8dfd825c45ae488a2933079a22cc16" => :high_sierra
    sha256 "f9b8f4bb66a7c2b8fe131755efaf1e22ca2b777dbe221e7a4b7f2a9d579d8f42" => :sierra
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
