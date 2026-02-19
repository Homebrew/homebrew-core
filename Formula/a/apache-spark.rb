class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-4.1.1/spark-4.1.1-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-4.1.1/spark-4.1.1-bin-hadoop3.tgz"
  version "4.1.1"
  sha256 "f5874d9d6a4935f26bc9f761467971d26812a17d94c6493b8eb4b810e7db31ae"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https://spark.apache.org/js/downloads.js"
    regex(/addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7cde4c6decf8ac3a4272f63d6ed60ee578413a7fec9dae076284b8d31d36640b"
  end

  depends_on "openjdk@21"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm(Dir["bin/*.cmd"])
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Language::Java.overridable_java_home_env("21")[:JAVA_HOME])
  end

  test do
    require "pty"

    (testpath/"data.txt").write <<~EOS
      Homebrew test
      Homebrew Spark test
      Spark test Homebrew
    EOS

    output = ""
    PTY.spawn(bin/"spark-shell") do |r, w, pid|
      w.puts "sc.parallelize(1 to 1000).count()"
      w.puts 'sc.textFile("data.txt").filter(line => line.contains("Spark")).first()'
      w.puts ":quit"
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      # remove ANSI colors
      output.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      output.gsub!(/\e\[([;\d]+)?m/, "")
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Long = 1000", output
    assert_match "String = Homebrew Spark test", output
  end
end
