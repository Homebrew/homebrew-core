class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.3.2.tar.gz"
  sha256 "50bad065ae0ea23ba76d929b0f504530127065fe6c097d291e82c4533ffd54ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2d0e4e422cc470a72d31549368f6d69ac5042c1912ed54425a7c85b9bae7bc6b"
    sha256 cellar: :any_skip_relocation, catalina: "297bc72fe0104aac61a2398ca248225abc9611f8d37e581a25b2c28b4de93e92"
    sha256 cellar: :any_skip_relocation, mojave:   "a6475a9f224d106e26b01171c52ebd73d23cdee971a1ece04ea70f6d02d869e1"
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
