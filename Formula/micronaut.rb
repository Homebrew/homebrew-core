class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.0.0.RC1.tar.gz"
  sha256 "91dc71b200c598a91b95a20792dcc3f3cb160b8e169b581f6b98689dc713acad"

  GRAALVM_HOME="./graalvm/Contents/Home".freeze

  depends_on :java => ["1.8", :build]

  def install
    with_env "GRAAL_OS" => "darwin-amd64", "GRAAL_VERSION" => "20.1.0" do
      system "./install-graal.sh"
    end
    system "#{GRAALVM_HOME}/bin/gu", "install", "native-image"
    with_env "JAVA_HOME" => GRAALVM_HOME do
      system "./gradlew", "micronaut-cli:shadowJar", "--no-daemon"
    end
    system "echo", "#{GRAALVM_HOME}/bin/native-image", "--no-fallback", "--no-server", "-cp",
            "starter-cli/build/libs/micronaut-cli-#{version}-all.jar"
    system "#{GRAALVM_HOME}/bin/native-image", "--no-fallback", "--no-server", "-cp",
            "starter-cli/build/libs/micronaut-cli-#{version}-all.jar"
    bin.install "mn"
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
