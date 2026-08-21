class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://gitbucket.github.io/"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.47.0/gitbucket.war"
  sha256 "7dd5c864e15eab9cd649694ceff541c5d2b053732619cdc9ea56c5bf63d276c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e948ec4e30c4f38fffe3ed25b71c3a07ba074428253d43626fcdbd94a88cfd7"
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
    run [
      formula_opt_bin("openjdk")/"java",
      "-Dmail.smtp.starttls.enable=true",
      "-jar",
      opt_libexec/"gitbucket.war",
      "--host=127.0.0.1",
      "--port=8080",
    ]
  end

  test do
    java = formula_opt_bin("openjdk")/"java"
    fork do
      $stdout.reopen(testpath/"output")
      exec "#{java} -jar #{libexec}/gitbucket.war --port=#{free_port}"
    end
    sleep 12
    refute_match "Exception", File.read("output")
  end
end
