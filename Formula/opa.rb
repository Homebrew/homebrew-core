class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.10.2.tar.gz"
  sha256 "2ffcbd4bb57790a7c397f15af6f88bad468c98dcf75bee48eb040f52c96bbc1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "df64c27d4b39d0762d125d8368cace9d44508fb66a64b808e8d5c64f0d39022c" => :mojave
    sha256 "c3e4a2baaff9d70e205d82317beb6164d13503e3b71b42d6c87ac7564733a24c" => :high_sierra
    sha256 "558d64e6fc846b0c8f372c357de0bc9ac37323b9c2f158e12e973f1a607a1140" => :sierra
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
