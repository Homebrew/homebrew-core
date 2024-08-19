class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.36.1",
      revision: "37d2f2872bfecd6927469f384be4951805aa4caa"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "785d838aae9e9bbfa8b9f9300c2db9385acc9bbf48b3d26acf6061987caa180a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c0ac6034f0bd8b55f2f54b16707070233e42dc9e80560b5cb582952557fffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e88d4cb4827365528a43aeadcf9dfa48a24e46d7d3f4f2bb629a7409c0cb3e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "09ae8d3dc82826e89e4fcb54f15d697d04091b7e46ce8a79ac9ff647dbde72bd"
    sha256 cellar: :any_skip_relocation, ventura:        "f6b9456b2e2a65da474f74fbd435d15d62515d784218653d0a3af1571c575dd4"
    sha256 cellar: :any_skip_relocation, monterey:       "60d19779010df0f805c1d4ebbde79d84eeb6a56fbeebc69eba432b802e708189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78fba18534eee1cc6a6ca19c79a8e235a1e02f0b0b4b7cfec332b667fbfaae45"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    output = shell_output("#{bin}/operator-sdk version")
    assert_match "version: \"v#{version}\"", output
    assert_match stable.specs[:revision], output

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
    assert_match "$ operator-sdk create api", output

    output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
    assert_match "$ make manifests", output
  end
end
