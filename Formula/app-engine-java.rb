class AppEngineJava < Formula
  desc "Google App Engine for Java"
  homepage "https://cloud.google.com/appengine/docs/java/"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.50.zip"
  sha256 "7be2537d76f425a7dcb93c2d2714092ff206c39a14b629b9fab9ece8bd9066de"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script %w[appcfg.sh dev_appserver.sh endpoints.sh google_sql.sh].map { |fn| libexec/"bin/#{fn}" }
  end

  test do
    (testpath/"WEB-INF/web.xml").write "<web-app/>"
    (testpath/"WEB-INF/appengine-web.xml").write "<appengine-web-app><threadsafe>true</threadsafe></appengine-web-app>"
    Process.setsid
    IO.popen("#{bin}/dev_appserver.sh . 2>&1") do |io|
      assert_not_nil(io.gets, "Dev App Server terminated prematurely") until $_ == "INFO: Dev App Server is now running\n"
      Signal.trap "INT", "IGNORE"
      Process.kill "INT", 0
    end
    assert_equal(130, $?.exitstatus, "Dev App Server exited with unexpected status code")
  end
end
