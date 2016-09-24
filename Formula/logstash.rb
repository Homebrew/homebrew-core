class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"

  stable do
    url "https://download.elastic.co/logstash/logstash/logstash-2.4.0.tar.gz"
    sha256 "622c435c5c0f40e205fd4d9411eb409cc52992cf62dde4c7cd46e480cd8247cc"
    depends_on :java => "1.7+"
  end

  devel do
    url "https://download.elastic.co/logstash/logstash/logstash-5.0.0-alpha3.tar.gz"
    sha256 "22ab6665f1049e7df18f020ba5e1f5287bffa0b53e205b178e9e3364941550d1"
    version "5.0.0-alpha3"
    depends_on :java => "1.8"
  end

  head do
    url "https://github.com/elastic/logstash.git"
    depends_on :java => "1.8"
  end

  bottle :unneeded

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

    output = pipe_output("#{bin}/logstash -f simple.conf", "hello world\n")
    assert_match /hello world/, output
  end
end
