class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.3.1.tar.gz"
  sha256 "df2a770f09d9a13698a77c77792f49b1ae7f72a49f137ad4abde8f8acc2996e9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7c14b2d7acdc516063a7a47786a8437b1e2e3e2b5a63f721e7d4ffc3b31f26a0"
    sha256 cellar: :any_skip_relocation, catalina: "12996c1cbdbf4833117f51dec666b961a7d5e28a99da685683dc8fccc4ed6ea4"
    sha256 cellar: :any_skip_relocation, mojave:   "91956679cd8f6e797751f6c46ed635269d04777bc6183bd5b8a13aed9fb4306d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
