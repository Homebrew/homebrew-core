class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.1.0",
      revision: "9d27e224efac78fcc9354ece4e43a50eb30ea968"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a052c0cdcce583e75ac76ae4401cb13ba8e9c6d26e1f1c26c9b1ce285fe97a19" => :catalina
    sha256 "3a611f3c02f063cfdfb93efab0d80a3720ec08fd39d9a844b4651ce6df367561" => :mojave
    sha256 "fe693789e064921691cfef0fe4f57c0000186f80476de0f84b804235b2293a91" => :high_sierra
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
