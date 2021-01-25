class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.3.0",
      revision: "1abf57985b43bf6a59dcd18147b3c574fa57d3f6"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d998d4d9ecb84b837b1921d86414992b912daf17ae5f5b741336d429f7a8ae02" => :big_sur
    sha256 "a22d0f48e4c1e576dbdf49bec25d53b786bd277b67b91a332acb3788469c92e8" => :arm64_big_sur
    sha256 "2ed94d42e41836039a0123267f5dcda3841ce177f30bafdb23da10fa111f7ec3" => :catalina
    sha256 "77b5e1584361d8d1cce7e0b1ebff6e09e6f0de39102e8d167522151ca02674f0" => :mojave
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
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
