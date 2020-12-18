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
    sha256 "7cfc1f066570db5c847f1e6dbe94d04047a5860a293a75cc79ef6c9ed06d7b52" => :big_sur
    sha256 "9c5a65ecd8a7a880fb9313c9fdf00067468aaf758273dcc1c638cfcad982ce98" => :catalina
    sha256 "30c354c68fac5ef3f2f24d5ad7b5db531c053084f2fe726755397d4342eb84c0" => :mojave
    sha256 "f12d158290dbbe2ec76976da1082cf71b3a94b36a917b469735ab1ed66c0bc8d" => :high_sierra
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

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
