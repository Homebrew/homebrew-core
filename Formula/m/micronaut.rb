class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.10.tar.gz"
  sha256 "ea2ec2710d141c44204b4a78b4b7a26f9b727178ba167c5c0df6f38ef3765bb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a8eb119b2089cbe8706583dd021a806e0a4529fd97ad0f57fa62978682335e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "048996f7d1bceb1b13823769d00a8dd16221c7e9daa709118ce6c23b470f441e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095479590b415806d4774df9d55dd3cc764dcc3f47dbb9ddcaea8f522cf34ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e3f2797cf6e7ed95cb5a65cdab638ea3262c818e296ed58073596f886891371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2ee7b1f11c88c38baa72d4120ad250bcd7707811957e968aa6b257b60b8eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a272e48b36785cfdcf760a7bcba8dfc182fc751784ba0741f28ea14c42a04c"
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
