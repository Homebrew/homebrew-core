class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.2.2.tar.gz"
  sha256 "b57379acf44a533443bed942e21ae8391ee057e3cfd684b47ba60401b3e53e03"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1434c2fca1c9972d2f37a2a0fa8c991a32a597ba01633d2c8c5a018f7d2790ee" => :big_sur
    sha256 "1c856d0b6ee5c23a910ddd5b149a6bb742232f35fb3d6973f2e9270c65cc9026" => :catalina
    sha256 "c99928829b56cb4277f6c3dd9aefe5b0006e815626aadd03cb41ce73789a3815" => :mojave
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
