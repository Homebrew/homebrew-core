class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.28.0",
      revision: "484013d1865c35df2bc5dfea0ab6ea6b434adefa"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "543216ad9178837817d02103bdf94fb45a4d7f2e55b8cf183072ad87b5302596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9438e91689988a5824a9da738fa46dffd7d077b213022a1184000d7d5215a038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37286ce81c439bfb159edf840148b4878bd6c35ac8bad75f911dfa5d1915c94b"
    sha256 cellar: :any_skip_relocation, ventura:        "b27b724626c828f9fa99fb14cd03277600ddf86589587a70f76f946e32372043"
    sha256 cellar: :any_skip_relocation, monterey:       "46eb6de55a233ba346c6153b836e8df8b686e6ff0f710a960651f6532534f65f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4b480ab2962a97ed7fbfb235abefbbf8491307ab7a9078bba5f267845479d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708ba0f99a619d51311b305970bc36412002a0a730767d522d03b97f47abbc54"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
