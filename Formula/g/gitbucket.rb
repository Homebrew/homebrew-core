class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://gitbucket.github.io/"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.46.1/gitbucket.war"
  sha256 "569e676946a679abf95e1257d44442647d10896b92b94ed02205fd0034547575"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f094c4e712632845287b3bf2e4dfc473a99eb2c8b309ee66bb0946f29264953c"
  end

  head do
    url "https://github.com/gitbucket/gitbucket.git", branch: "master"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "sbt", "executable"
      libexec.install "target/executable/gitbucket.war"
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
    refute_match "Exception", File.read("output")
  end
end
