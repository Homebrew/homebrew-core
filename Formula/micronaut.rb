class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.4.1.tar.gz"
  sha256 "cb5c5726d74232cc3967fccbf4b52480bdccae366cb92c3af74debc2e0137c57"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c29fada4f38c7b308c0ba34f4cf9feba8124eb30635599980ff749868a6a3952"
    sha256 cellar: :any_skip_relocation, catalina: "e4cd323f3bbe3c5a7891f557e5bba4b8b1ee280a7a899daf9395fb979baada04"
    sha256 cellar: :any_skip_relocation, mojave:   "5e67f7c759113b9324445dd0cf88168afe355a5448a79c52fb34e9c113d48b3d"
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
