class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.4.0.tar.gz"
  sha256 "6ed65927cd280d0a6606df5076cddc9206aee1ba40de1b6592f6fd40fc124894"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a40bdc09c47ce1163b7b70e7c21cae8b727af350d1b8ee3f38494e2e250ac0c5"
    sha256 cellar: :any_skip_relocation, catalina: "c21d8b5b29371ba0865a137a58fbc7f373774ca7937b5303ad44dacac9aa3e28"
    sha256 cellar: :any_skip_relocation, mojave:   "1560420aa23bba3f74215f9ecf8e8ac055c85045ed3de9d8426f8bf74259e485"
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
