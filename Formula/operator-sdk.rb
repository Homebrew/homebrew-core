class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.10.1",
      revision: "5b69c2803890aa841fb361a4b9526dd251fe02e6"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90367c835b6806140ddfbbf2f1a3cb7bfe373c6ea7201240fee521dd59a575a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "da84773b99a524fa3075b852fdac4636e287c737d59dd7954b8f79693f5c2836"
    sha256 cellar: :any_skip_relocation, catalina:      "db98899bbf6469f7c939e5a01afced6274bdfc3764a48665ceba2f1bf757cdac"
    sha256 cellar: :any_skip_relocation, mojave:        "9e2356f2678c0660db6d375d9b9c67f6771a484f2ea3ca1d692c811f2c1e4c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8250e4a268f9a0435d316f0570bb09f1e48932a1dc7005b73f1ff023e6f1910"
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
