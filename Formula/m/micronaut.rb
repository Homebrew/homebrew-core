class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.9.1.tar.gz"
  sha256 "f30e012576da47a3ffcbf761e7816c45001a59b05ecaa3e9e434e9f6c7037082"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c967b0531c15292a40e32af63012a784da17b56e4591ec87938e1d4c37e6ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14c6c0324d738201e4c97f4b49bbf87b384ecf6ef8ec562b1c96500fab1a6151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dd67480e2123fd329b3ed67dd987530013b5ee79dd87117b8f12169523f13ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1d40b2b116f1bde5ef3a5a8155d4c08e8c4d02204070a409768655eda737bd"
    sha256 cellar: :any_skip_relocation, ventura:       "1138bfb29f17db49cade353cc0e2b00dc86ed61690e6401da03fdd2d9ced12d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8149ed5687e51d1d7248fcd4f68d96caeac189f18da53d219d39ac3d4569738c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2fa4629109d28210d496b82851267ea1f75dce7758c324605e8a014af5d1364"
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
