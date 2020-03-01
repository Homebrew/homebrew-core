class Blazegraph < Formula
  desc "Graph database supporting RDF data model, Sesame, and Blueprint APIs"
  homepage "https://www.blazegraph.com/"
  url "https://downloads.sourceforge.net/project/bigdata/bigdata/2.1.5/blazegraph.jar"
  sha256 "fbaeae7e1b3af71f57cfc4da58b9c52a9ae40502d431c76bafa5d5570d737610"

  bottle :unneeded

  # dependnecy can be lifted in the upcoming release, > 2.1.5
  depends_on :java => "1.8"

  def install
    libexec.install "blazegraph.jar"
    bin.write_jar_script libexec/"blazegraph.jar", "blazegraph", :java_version => "1.8"
  end

  plist_options :startup => "true", :manual => "blazegraph start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/blazegraph</string>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    server = fork do
      exec bin/"blazegraph"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_predicate testpath/"blazegraph.jnl", :exist?
    assert_predicate testpath/"rules.log", :exist?
  end
end
