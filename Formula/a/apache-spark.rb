class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-4.0.0/spark-4.0.0-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-4.0.0/spark-4.0.0-bin-hadoop3.tgz"
  version "4.0.0"
  sha256 "2ebac46b59be8b85b0aecc5a479d6de26672265fb7f6570bde2e72859fd87cc4"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https://spark.apache.org/js/downloads.js"
    regex(/addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57dc64a028ae181115603613203c66f9bc249c87b547f83cd17cff03399b8509"
  end

  depends_on "openjdk@17"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm(Dir["bin/*.cmd"])
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Language::Java.overridable_java_home_env("17")[:JAVA_HOME])
  end

  test do
    require "pty"

    output = ""
    PTY.spawn(bin/"spark-shell") do |r, w, pid|
      w.puts "sc.parallelize(1 to 1000).count()"
      w.puts "jdk.incubator.foreign.FunctionDescriptor.TRIVIAL_ATTRIBUTE_NAME"
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
    assert_match "String = abi/trivial", output
  end
end
