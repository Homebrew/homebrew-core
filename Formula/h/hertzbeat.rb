class Hertzbeat < Formula
    desc "Apache HertzBeat(incubating) is a real-time monitoring system with agentless, performance cluster, prometheus-compatible, custom monitoring and status page building capabilities."
    homepage "https://hertzbeat.apache.org/"
    url "https://www.apache.org/dyn/closer.lua/incubator/hertzbeat/1.7.0/apache-hertzbeat-1.7.0-incubating-bin.tar.gz"
    sha256 "c593aa8f3e1ae74f2b093bffe60167f5b5780a21a35dde95ed243f1c9bd2e46b"
    license "Apache-2.0"

    depends_on "openjdk@17"

    def install
        libexec.install Dir["*"]
        (bin/"hertzbeat").write_env_script libexec/"bin/startup.sh",
            Language::Java.overridable_java_home_env("17")
    end

    def caveats
        <<~EOS
            HertzBeat requires Java 17 or later.
            The data directory is located at:
                #{var}/hertzbeat
        EOS
    end

    service do
        run [opt_bin/"hertzbeat"]
        keep_alive true
        log_path var/"log/hertzbeat.log"
        error_log_path var/"log/hertzbeat.log"
        working_dir var
    end

    test do
        port = free_port
        fork do
            exec bin/"hertzbeat"
        end
        sleep 60
        system "curl", "-f", "http://localhost:#{port}"
    end
end