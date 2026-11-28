class AlloydbAuthProxy < Formula
  desc "Utility for connecting securely to your AlloyDB instances"
  homepage "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy"
  url "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "2efd44c227a0a725cc2f38de129c8a82bb4c88d5f61bdc1250650aab56e253ff"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy.git", branch: "main"

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"alloydb-auth-proxy", shell_parameter_format: :cobra)
  end

  test do
    require "net/http"
    require "timeout"

    health_port = free_port
    instance = "projects/test-project/locations/test-region/clusters/test-cluster/instances/test-instance"
    with_test_process(bin/"alloydb-auth-proxy", "--token", "test-token", "--lazy-refresh",
                      "--port", "0", "--health-check", "--http-port", health_port.to_s,
                      "--exit-zero-sigterm", instance) do |pid|
      health = Net::HTTP.new("127.0.0.1", health_port, nil)
      health.open_timeout = 2
      health.read_timeout = 2

      response = nil
      Timeout.timeout(15) do
        loop do
          response = health.get("/startup")
          break if response.code == "200"

          sleep 0.1
        rescue Errno::ECONNREFUSED
          sleep 0.1
        end
      end
      assert_equal "200", response.code
      Process.kill("TERM", pid)
      _, status = Timeout.timeout(10) { Process.wait2(pid) }
      assert_predicate status, :success?
    end
  end
end
