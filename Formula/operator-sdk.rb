class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.23.0",
      revision: "1eaeb5adb56be05fe8cc6dd70517e441696846a4"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f89f13aef4b9dc7828df49f06eedd57f3be04e34bdf683df51119b71c0c4ff1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9cb060ceb9b32112fea719b0d202d8abeeba9b935cb7c5b718fe82503c934d7"
    sha256 cellar: :any_skip_relocation, monterey:       "8951bfdadac29dea267dd06dc756f2c543d1b35f6ddf642f08ee847d0842f46a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bda989ae943cda831496e5b9e4cf0ca22b87f7a9c5c79aa7efc3e5b75a4f0f17"
    sha256 cellar: :any_skip_relocation, catalina:       "51c57d1728921fc8d7e4384c0fe04cdf840b9abfa45b6abe2902ff2c7281e3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2b7bea7f3e8b8575eef6e16abccb8626dd513e6a562be19b3efd439906c6c28"
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
