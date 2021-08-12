class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.36.1/gitbucket.war"
  sha256 "e836955d504ab5b347c29e76f46218b3d2390fee53b834d54c11f4c67c8558f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d66ac992d7868e18152a813bc1dc8baa436aa6befab5a81b1d8b9534b5df335f"
  end

  head do
    url "https://github.com/gitbucket/gitbucket.git"
    depends_on "ant" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "ant"
      libexec.install "war/target/gitbucket.war", "."
    else
      libexec.install "gitbucket.war"
    end
  end

  def caveats
    <<~EOS
      Note: When using `brew services` the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"gitbucket.war",
         "--host=127.0.0.1", "--port=8080"]
  end

  test do
    java = Formula["openjdk"].opt_bin/"java"
    fork do
      $stdout.reopen(testpath/"output")
      exec "#{java} -jar #{libexec}/gitbucket.war --port=#{free_port}"
    end
    sleep 12
    File.read("output") !~ /Exception/
  end
end
