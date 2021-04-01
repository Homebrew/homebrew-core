class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.4.2.tar.gz"
  sha256 "dffdc386b378ab9fb4367b9802e351216da0e248fff4607123e49cc83b5ed4ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d5ab03fd173b8f2bdef0a9b4cb84384c6f6ec3c85c6f2a980619fea1e486bb03"
    sha256 cellar: :any_skip_relocation, catalina: "b41191654d1367d0de6e95d4ffe55b9a1dad6cd7eb42426841aa1eef7073f4eb"
    sha256 cellar: :any_skip_relocation, mojave:   "7fc6a36f6a6830d56a6c7013fdf558390872f6fd9f8a4040d0b0ca7f8532c3c2"
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
