class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.8.2.tar.gz"
  sha256 "d768dce993cdcd4ae56c9da689dbf168aaa46f051906408388fb6391bd5da60c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a8f30b0de3d8e2954f4c945fcf51ffe16ab43d916648863a42c58a6548cf6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29fd88aeb5c52f58568540efdc57b5f1776e53ebd98472de962d9d9fc0bdc387"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d255cf754fe77aa497eb9860735d733722587fbd4cf9f251acbe5a88f12f148b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b5729824f9d66059db65e654460f0d93cd53d0c7767b6e9dc85187538c02fb9"
    sha256 cellar: :any_skip_relocation, ventura:       "4bebccef3affccbf431c1f03a83f320e2d850e855d9e60aaf1cb93f5c33a1f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eadd7a5c96c83b82a3d79d2ec4ed9450b76b3d9b824f8f379a422c18031bff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe630d48eabf62824767519ae2afb5df5a85e877006800182d605ac154ef55e"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
