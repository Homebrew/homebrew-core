class Kyuubi < Formula
  desc "Serverless SQL on data warehouses and lakehouses"
  homepage "https://kyuubi.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=kyuubi/kyuubi-1.7.0/apache-kyuubi-1.7.0-bin.tgz"
  mirror "https://archive.apache.org/dist/kyuubi/kyuubi-1.7.0/apache-kyuubi-1.7.0-bin.tgz"
  sha256 "beaf25f2c466f4cd03bcfcc7e0c6a63c51cfe5811f524fdc810550239eded461"
  license "Apache-2.0"
  head "https://github.com/apache/kyuubi.git", branch: "master"

  depends_on "apache-spark"
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]

    setting = {
      JAVA_HOME:            Language::Java.overridable_java_home_env("1.8")[:JAVA_HOME],
      KYUUBI_HOME:          libexec.to_s,
      KYUUBI_LOG_DIR:       "${KYUUBI_LOG_DIR:-#{var}/kyuubi/logs}",
      KYUUBI_PID_DIR:       "${KYUUBI_PID_DIR:-#{var}/kyuubi/pid}",
      KYUUBI_WORK_DIR_ROOT: "${KYUUBI_WORK_DIR_ROOT:-#{var}/kyuubi/work}",
      SPARK_HOME:           Formula["apache-spark"].opt_libexec.to_s,
    }
    (bin/"kyuubi").write_env_script libexec/"bin/kyuubi", setting
    (bin/"kyuubi-beeline").write_env_script libexec/"bin/beeline", setting
  end

  def post_install
    %w[logs work pid zk].each do |dir|
      (var/"kyuubi"/dir).mkpath
    end
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    ENV.append "_JAVA_OPTIONS", "-Dkyuubi.frontend.bind.host=localhost"
    ENV.append "KYUUBI_WORK_DIR_ROOT", testpath/"work"

    fork do
      exec bin/"kyuubi run"
    end
    sleep 10

    expected = "\n+-----+\n| c0  |\n+-----+\n| 1   |\n+-----+\n"
    result = shell_output("#{bin}/kyuubi-beeline --silent -u 'jdbc:hive2://localhost:10009/' -e 'SELECT 1 as c0'")
    assert_match expected, result
  end
end
