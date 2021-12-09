class AppEngineJava < Formula
  desc "Google App Engine for Java"
  homepage "https://cloud.google.com/appengine/docs/java/"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.83.zip"
  sha256 "1d585a36303c14f4fa44790bba97d5d8b75a889ad48ffce8187333488511e43e"

  bottle do
    sha256 cellar: :any, all: "6c906b7bc3896476230775f5b32b4864576768a2a3d5e3b160db0fd7b31ce346"
  end

  # https://cloud.google.com/appengine/docs/standard/java/sdk-gcloud-migration
  deprecate! date: "2019-07-30", because: :deprecated_upstream

  depends_on "openjdk@8"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]

    %w[appcfg.sh dev_appserver.sh endpoints.sh run_java.sh].each do |f|
      bin.install libexec/"bin/#{f}"
    end

    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk@8"].opt_prefix)
  end

  test do
    (testpath/"WEB-INF/web.xml").write "<web-app/>"
    (testpath/"WEB-INF/appengine-web.xml").write \
      "<appengine-web-app><threadsafe>true</threadsafe></appengine-web-app>"
    Process.setsid
    IO.popen("#{bin}/dev_appserver.sh . 2>&1") do |io|
      until $LAST_READ_LINE == "INFO: Dev App Server is now running\n"
        refute_nil io.gets, "Dev App Server terminated prematurely"
      end
      Signal.trap "INT", "IGNORE"
      Process.kill "INT", 0
    end
    assert_equal(130, $CHILD_STATUS.exitstatus, "Dev App Server exited with unexpected status code")
  end
end
