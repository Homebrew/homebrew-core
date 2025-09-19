class Burrow < Formula
  desc "Kafka Consumer Lag Checking"
  homepage "https://github.com/linkedin/Burrow"
  url "https://github.com/linkedin/Burrow/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "2881112e8fb4e5a662389a582c6044ed0e3359a03e26f446b8242929a7f82423"
  license "Apache-2.0"
  head "https://github.com/linkedin/Burrow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea73dcbf2cb990d1c0c98695f2f26c29fde6a6a333b29f3bfaa8e604dec5def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c277d2114d19c72bcd48525fefa763e967cd35b0254f41b9fd1e7e4d320cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd6704cb95d0e1812e76fa40e6668e1514d425f2c4f2e256153466cb5953c0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e82bd82d515ddcec9ba8dc4644989438ae266b9a0b9d56254561d4999369c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "00d6a0fe41ae667421f4b20d13cbedf294cbdd0201808195bfe788c70cdc1217"
    sha256 cellar: :any_skip_relocation, ventura:       "b7ef8f3dc4e0da995455d8889a06b243a68fd850951286a43eae18c95731b467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5f3ab59d96b041b0ec3941520ea39accc326d4f1d7b3262fc9e4bae54e6b50f"
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
