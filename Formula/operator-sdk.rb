class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.0.0",
      revision: "d7d5e0cd6cf5468bb66e0849f08fda5bf557f4fa"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12a2f74aefa1080a6f5398a34a6fa3e5dbc073701d417f3c98b223004947f4b4" => :catalina
    sha256 "407b855e436cedc91a6be8c4e2280928a7267c0e468db1183919d11588b29b62" => :mojave
    sha256 "ec30eef2b5107b09652baee76189b8f9eff0d4d4be7f940e740b7baad521e68a" => :high_sierra
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      assert_match stable.specs[:revision], version_output
    end

    system bin/"operator-sdk", "init", "--domain=example.com", "--repo=example.com/example/example"
    assert_predicate testpath/"bin/manager", :exist?
  end
end
