class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.39.0/gitbucket.war"
  sha256 "ca7454a7fb472b61a0ca4ad056ae8930bdafd53b7cc6cd0fc3b30c6cf09c7666"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf311b3c11eb5aa696796227264dfa8a796a52a5bb2c4373493a3aa420a2aa61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eda39fbee0512a3e34ccb30eb23f6ddbfe6ced65e665a7cbfdb02846b489011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eda39fbee0512a3e34ccb30eb23f6ddbfe6ced65e665a7cbfdb02846b489011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eda39fbee0512a3e34ccb30eb23f6ddbfe6ced65e665a7cbfdb02846b489011"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf311b3c11eb5aa696796227264dfa8a796a52a5bb2c4373493a3aa420a2aa61"
    sha256 cellar: :any_skip_relocation, ventura:        "5eda39fbee0512a3e34ccb30eb23f6ddbfe6ced65e665a7cbfdb02846b489011"
    sha256 cellar: :any_skip_relocation, monterey:       "5eda39fbee0512a3e34ccb30eb23f6ddbfe6ced65e665a7cbfdb02846b489011"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eda39fbee0512a3e34ccb30eb23f6ddbfe6ced65e665a7cbfdb02846b489011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff39786b69d94da3c46979fe7ceb5dc9584a14a290420c9dc66ed5bc6f38a871"
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
