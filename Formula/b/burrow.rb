class Burrow < Formula
  desc "Kafka Consumer Lag Checking"
  homepage "https://github.com/linkedin/Burrow"
  url "https://github.com/linkedin/Burrow/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "9d9b7502cfbee6038af80c3bbfa651ae2437f07ec0756aa2b6c874d516b4ffae"
  license "Apache-2.0"
  head "https://github.com/linkedin/Burrow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b86ff8deae33789a7977472252996ce9bed5b9297186b7e3ada18b8ccb34531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96d98011b5b9e0943087196c71dbcf60904ab9e4e22602baeea422a96e488620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed299aece4ff3ffe4f5c676b3b2afda41d5d8a97dc937e3babceef7387dce6a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "261a4bfe121fa8af48ee190fdab037c5c16d65a5ee672d9b3a9cb90c68260e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e5b31685703828e5b444374c29942c97afbbb18d85959916d2a46778c9d0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1701af844c34f0f248f80cf39e42f0f75c29b39ca976acc8a129c8a382eb5168"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    inreplace "docker-config/burrow.toml" do |s|
      s.gsub!(/(kafka|zookeeper):/, "localhost:")
      s.sub! "docker-client", "homebrew-client"
    end
    (etc/"burrow").install "docker-config/burrow.toml"
  end

  service do
    run [opt_bin/"burrow", "--config-dir", etc/"burrow"]
    keep_alive true
    error_log_path var/"log/burrow.log"
    log_path var/"log/burrow.log"
    working_dir var
  end

  test do
    port = free_port
    (testpath/"burrow.toml").write <<~TOML
      [httpserver.default]
      address="localhost:#{port}"
    TOML
    spawn bin/"burrow"
    sleep 1

    output = shell_output("curl -s localhost:#{port}/v3/kafka")
    assert_match "cluster list returned", output
  end
end
