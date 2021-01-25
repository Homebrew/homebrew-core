class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.5.0",
      revision: "32c22239423b3b4ba6706d450bd044baffdcf9e6"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f3dadafcf2b3459c700710b81cefc40632a1da528d100db18aee39ebf7bc3d4" => :big_sur
    sha256 "0ca0668ef02cba3c0d8c1292d755f4192c261bb91162e006fc1560d9ae1a3728" => :arm64_big_sur
    sha256 "cdd5f1cb8e7ad44ee7d38bd623f3dd5e3f643fc49121a375330203d98b277b5f" => :catalina
    sha256 "09c685f41aa2ac740b4efdf36b5ebeb2fa8345939de02bf1aa6ac6037dea4791" => :mojave
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
