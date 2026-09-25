class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://gitbucket.github.io/"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.48.0/gitbucket.war"
  sha256 "bbd08775a5a19d51a4358f481fb16eceecb992b2b0c83bfac414e54717310359"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba514792f807df50229673e8aab37945e89b4a5e071c2a9626ff627943a812b5"
  end

  head do
    url "https://github.com/gitbucket/gitbucket.git", branch: "master"
    depends_on "sbt" => :build
  end

  depends_on "openjdk@25"

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
      formula_opt_bin("openjdk@25")/"java",
      "-Dmail.smtp.starttls.enable=true",
      "-jar",
      opt_libexec/"gitbucket.war",
      "--host=127.0.0.1",
      "--port=8080",
    ]
  end

  test do
    java = formula_opt_bin("openjdk@25")/"java"
    fork do
      $stdout.reopen(testpath/"output")
      exec "#{java} -jar #{libexec}/gitbucket.war --port=#{free_port}"
    end
    sleep 12
    refute_match "Exception", File.read("output")
  end
end
