class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"

  stable do
    url "https://artifacts.elastic.co/downloads/logstash/logstash-5.0.1.tar.gz"
    sha256 "d4cb9a624e12f8e4cf852a251c96b371094009b84a85231c9604ba7d6523da4d"
  end

  head do
    url "https://github.com/elastic/logstash.git"
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    if build.head?
      # Build the package from source
      system "rake", "artifact:tar"
      # Extract the package to the current directory
      mkdir "tar"
      system "tar", "--strip-components=1", "-xf", Dir["build/logstash-*.tar.gz"].first, "-C", "tar"
      cd "tar"
    end

    inreplace %w[bin/logstash], %r{^\. "\$\(cd `dirname \$SOURCEPATH`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash-plugin], %r{^\. "\$\(cd `dirname \$0`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash.lib.sh], /^LOGSTASH_HOME=.*$/, "LOGSTASH_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/logstash"
    bin.install_symlink libexec/"bin/logstash-plugin"
  end

  def caveats; <<-EOS.undent
    Please read the getting started guide located at:
      https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html
    EOS
  end

  test do
    (testpath/"simple.conf").write <<-EOS.undent
      input { stdin { type => stdin } }
      output { stdout { codec => rubydebug } }
    EOS

    mkdir testpath/"data"
    mkdir testpath/"logs"

    output = pipe_output("#{bin}/logstash -f #{testpath}/simple.conf --path.data=#{testpath}/data --path.logs=#{testpath}/logs", "hello world\n")
    assert_match /hello world/, output
  end
end
