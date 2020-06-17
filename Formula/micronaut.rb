class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  version "2.0.0.RC1"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v#{version}.zip"
  sha256 "7bbbcab85e70c126ea4ffb20c178b1fc17f44b9758df7d2f348e20920c79aad5"

  GRAALVM_HOME="./graalvm/Contents/Home"
  
  def install
    with_env "GRAAL_OS" => "darwin-amd64", "GRAAL_VERSION" => "20.1.0" do
      system "./install-graal.sh"
    end
    
    
    system "#{GRAALVM_HOME}/bin/gu", "install", "native-image"
    
    with_env "JAVA_HOME" => GRAALVM_HOME do
      system "./gradlew", "micronaut-cli:shadowJar", "--no-daemon"
    end
    
    system "echo", "#{GRAALVM_HOME}/bin/native-image", "--no-fallback", "--no-server", "-cp", "starter-cli/build/libs/micronaut-cli-#{version}-all.jar" 
    system "#{GRAALVM_HOME}/bin/native-image", "--no-fallback", "--no-server", "-cp", "starter-cli/build/libs/micronaut-cli-#{version}-all.jar" 
    
    bin.install "mn"
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
