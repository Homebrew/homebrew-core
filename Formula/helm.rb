class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.6.0",
      revision: "7f2df6467771a75f5646b7f12afb408590ed1755"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a634b6c75bf040bf5da284c1fc70c5c234852fba1d525fb29b6b1588e863b4d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "65bdb22434cc865a336b38bb2c53b5b0db14c71fb443d02fe7b64f6af5e7b358"
    sha256 cellar: :any_skip_relocation, catalina:      "fc02bd64309b5c7ebddbf30e02826a0df61bddc43d989bb0df5d4b9842e8ef8a"
    sha256 cellar: :any_skip_relocation, mojave:        "78e275191a7b76c2be677a27fbbe27b540df2c0c02dcbc4e3f66436a84fcd5ff"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
