class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.13.5.tar.gz"
  sha256 "964263296302c9cd1ac3d23ceb433d25760121fca1c42c9a7fd866d90b2a7125"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e5aa20d80b058490de0342328035788439aca9e86b87f5ffd3edef58e188fb0" => :mojave
    sha256 "1a03410a8ec13ddee8a748dc84db4e90348df552af0984722231667ac6bd4b60" => :high_sierra
    sha256 "f9148345593ce2df43531666bab4dd4b50890a9adc4d362de9da89f9cb876603" => :sierra
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
