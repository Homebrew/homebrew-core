class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.13.1",
      revision: "1659ab58a073999463e6dcdf18bdc359a315e091"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff76055163da65d39dc81d7e54727c48f4fa08c94256a032b753642be622e7e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3b13b26fab219ca3080ea9179a8c769d55ecdd4635279ceb087a0f5b4a3187f"
    sha256 cellar: :any_skip_relocation, catalina:      "73a19fa28d419b8975433ed86cc49e49d10419f1bd5ad02fab1d8700f6a9fb6a"
    sha256 cellar: :any_skip_relocation, mojave:        "81886126e2b98a5ff79ffafe4eccdb5b62fd9cc2db623f0e780f927bbf7221c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96c13f45de7452f291fc4277682a4fd650762d9a79c817b62efaefa560aa0e9"
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
