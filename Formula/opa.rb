class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.13.5.tar.gz"
  sha256 "964263296302c9cd1ac3d23ceb433d25760121fca1c42c9a7fd866d90b2a7125"

  bottle do
    cellar :any_skip_relocation
    sha256 "092068ff7d0bc10221d755f2430566e6159f7f90420364777711e8850758a59e" => :mojave
    sha256 "27a0ee6dc895c6096651e02fb9eff11b4d2025522b9516dba00f1f4164a34d84" => :high_sierra
    sha256 "cbc573e81ea9be57104fdc842068490ac0fa92a0ef8ac62f5e4d3c103a28bd40" => :sierra
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
