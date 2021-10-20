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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a4b7a71081b00286227b6e41fcb8e38f8802af7eff94e099aabe2f9105f56a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a7c04a325f962c86b5cd7511d94ba179d959307d540665fdf0a2cf1d4679c69"
    sha256 cellar: :any_skip_relocation, catalina:      "9293b50b9f1aaf743a96d37d43f9943d430f74f16b62add781bb1449f21b7c74"
    sha256 cellar: :any_skip_relocation, mojave:        "5c43aaeda2865b80c09e371cb51e50aa49e7ce1503ccd075cd4921a5144a434f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18142a17499611b3473a0a5cc0c89c8e574f3ae4b689c1bbaf7e429e136d0c62"
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
