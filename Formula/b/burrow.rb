class Burrow < Formula
  desc "Kafka Consumer Lag Checking"
  homepage "https://github.com/linkedin/Burrow"
  url "https://github.com/linkedin/Burrow/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "3dcb0af9ff5741c2d2b3ac39211b9087e1f5dfc7f45ffa18bf9007504d91219f"
  license "Apache-2.0"
  head "https://github.com/linkedin/Burrow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "243ce0a894c45933fa1c2fe39556babfe07671abfbdcaec3ab14235b3dfda27a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ef8b2be08cbdf13d7e9ee11416561152f0febd300210ca820b9aa57dba38b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4e89ff03e3e70c5f35802ec731ae49c517d5f79395b4518c37f30215f374160"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a76e2fd9fca492a15588e587519f05ace8ad1868b75f06826cb80e8c0635752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041604be36e122097bbfab788ab2ad348b1b47f89568ecae6169e306b44b1667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3afc1b575e3538fc54e30cba0c8909f5a9dcb9a10e3633d6e22ef693a35d4d51"
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
