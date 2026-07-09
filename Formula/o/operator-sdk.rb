class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.42.3",
      revision: "2016cae87253bef07444dd47c463bdbb27c44c48"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d5de988fb4e50885833484a2c3c3f386d10c252633ca5f7bb3e3db2fd396307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75aa5bd479a8b18b49504a40d3d101c7bddf6e2d4d56a9c4c88d21afec58dda3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bfb6d07830e935e826e713ea514d5a3cc995814b2073c1637a088e5319afbfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f4398cb55f8acdc69aaf3c09e974ae958b1204a90e9518e5be90665fa612642"
    sha256 cellar: :any,                 arm64_linux:   "6814ef6055058ba3b73b8fd0e91902bb868de3a0428a2ba23426366fbb707fd4"
    sha256 cellar: :any,                 x86_64_linux:  "8c4ef39cf977794e54b2ce52d4fd288b0f5df39d7a5e0ba14175e88f0bad6ffc"
  end

  depends_on "pkgconf" => :build
  depends_on "go"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["GOBIN"] = bin
    system "make", "install", "CGO_ENABLED=1"

    generate_completions_from_executable(bin/"operator-sdk", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/operator-sdk version")
    assert_match "version: \"v#{version}\"", output
    assert_match stable.specs[:revision], output

    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"

      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
