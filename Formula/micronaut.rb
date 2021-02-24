class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.3.3.tar.gz"
  sha256 "426eecbd01739b6e933c6d1da36bec1a7e7ea9ed42c51ebc5a84b45e903c297d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "21cac04676103aaa93717f6df7e06446176c3ff10d896eaaeec2233c7debb06a"
    sha256 cellar: :any_skip_relocation, catalina: "4646ba77ac48215511bd9a60693ecb3126480849874b230cbcfc3f5848c772a9"
    sha256 cellar: :any_skip_relocation, mojave:   "5b64bf426e89a27f3c9392ade6af3606524fa2af91c4c9a519a7c044398faea5"
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
