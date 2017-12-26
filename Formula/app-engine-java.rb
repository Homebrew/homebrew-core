class AppEngineJava < Formula
  desc "Google App Engine for Java"
  homepage "https://cloud.google.com/appengine/docs/java/"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.60.zip"
  sha256 "dca83a6b7a0dcb1a30b268f167dac1e12405f4fe570b02997ffeae6ad5d44d95"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]

    %w[appcfg.sh dev_appserver.sh endpoints.sh run_java.sh].each do |f|
      bin.install libexec/"bin/#{f}"
    end

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
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
