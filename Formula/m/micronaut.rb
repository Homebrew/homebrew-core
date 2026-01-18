class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.7.tar.gz"
  sha256 "4cfb7dca4ebbf5078832956b9627b3769f3763afa7916cc7f747102e3a81eecd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33bfd86dad8184009d2378ba5fefbdb8b10e2f892d52a58292fbc05580fb2cff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97e0e8eb3dd740eab27355ae9418c2fd1abaee35bd44fa9fae9b3f7a038367b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca523d949d67534328ade52077ae2d90aa9907a73ef725d88a84b80a2ae02bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab429c3f1a625f0ed89075f5e7a69204cca2bd2fad6ba9fc1d204c0ee8d90d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63aef0c5357a0a57fa38d4304d5ea594baf1494d506ae5516eb84ed30619fea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f4e84e726eeaf9664067c80d38d50b9043630c492e091329d59270053a4373"
  end

  # Issue ref: https://github.com/micronaut-projects/micronaut-starter/issues/2848
  depends_on "gradle@8" => :build
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
