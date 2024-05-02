class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.40.0/gitbucket.war"
  sha256 "7e124543a48f3d349b2e93dddbaace1a7122a18b1a11b0e6ab403f0645d646d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c987e6512cd806f10867ea20dd4f89252f3434aca0b88bb4466d5f6749cff2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c987e6512cd806f10867ea20dd4f89252f3434aca0b88bb4466d5f6749cff2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c987e6512cd806f10867ea20dd4f89252f3434aca0b88bb4466d5f6749cff2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c987e6512cd806f10867ea20dd4f89252f3434aca0b88bb4466d5f6749cff2b"
    sha256 cellar: :any_skip_relocation, ventura:        "1c987e6512cd806f10867ea20dd4f89252f3434aca0b88bb4466d5f6749cff2b"
    sha256 cellar: :any_skip_relocation, monterey:       "1c987e6512cd806f10867ea20dd4f89252f3434aca0b88bb4466d5f6749cff2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2837bebb2f01687b9ecb65795ca7bf7f62f80e9b7ee298f7eacb1ea340889c"
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
    File.read("output").exclude?("Exception")
  end
end
