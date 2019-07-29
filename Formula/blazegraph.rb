class Blazegraph < Formula
  desc "Graph database supporting RDF data model, Sesame, and Blueprint APIs"
  homepage "https://www.blazegraph.com/"
  url "https://downloads.sourceforge.net/project/bigdata/bigdata/2.1.4/blazegraph.jar"
  sha256 "b175d2b4aa9e2f65fcbf4d6f75f8dd12ef75022f82fb94df1fbd0bac5230af2a"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "blazegraph.jar"
    bin.write_jar_script libexec/"blazegraph.jar", "blazegraph"
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
    server = fork do
      exec bin/"blazegraph"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_predicate testpath/"blazegraph.jnl", :exist?
    assert_predicate testpath/"rules.log", :exist?
  end
end
