class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.41.0/gitbucket.war"
  sha256 "d1de0a96569b7fc69b11a1c98556f17ba36eb51305d93cb3c3166f5111d2eeca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e2b7e1c29ef2d14534e0cb59dad266bfc8499260a4809a59b24c087f765a708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b80b2224664d3e431c1f8ec74165939ca009fe8eb347680da2e144fc18ae82b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705df2f7579c63032cd99cd200bc366df5479ef23c4000706b0014d7e1cf99a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf66e5b7e9c664c797c442e96d2040378e3c6a0986c0a13364d696eb301623bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcd6ff07d7a73b23021a0ebbe38042b806b91c8c18367196cad6ca3546699a79"
    sha256 cellar: :any_skip_relocation, ventura:        "a59888b16d7472e43ebe0c3aea69e2562dd45b53475c93f2ab545d492313bffe"
    sha256 cellar: :any_skip_relocation, monterey:       "c44b62da4c1bb8d35f671f1647663a045fe600a2b55a44668cc7de2121b5f5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a31f9dfa84d272598d7f896d156aa7c644e5c5b2c5bc60bee5d420889675254"
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
