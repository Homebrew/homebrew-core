class AppEngineJava < Formula
  desc "Google App Engine for Java"
  homepage "https://cloud.google.com/appengine/docs/java/"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.57.zip"
  sha256 "63f89be498d1e7462c03fe2b66d7773a9e5dd04ffb71e3b59a5fa74a7b810997"

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
      assert_not_nil(io.gets, "Dev App Server terminated prematurely") until $LAST_READ_LINE == "INFO: Dev App Server is now running\n"
      Signal.trap "INT", "IGNORE"
      Process.kill "INT", 0
    end
    assert_equal(130, $CHILD_STATUS.exitstatus, "Dev App Server exited with unexpected status code")
  end
end
