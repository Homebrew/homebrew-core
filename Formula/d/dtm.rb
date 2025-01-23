class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "97499e49afb8c433282844b13865b2d66eae36fb346795d1afb838d53753e06e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a7f087990e26662c07a007b1be3449b149893714c6d2313d97fd3692f655ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63c45a54c45da8f99b35a6fcb77fe61c7ffb569f91ab0b9512b5402f99c3736d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72464eb0df2c29f9e37cfc324e70c54539e8cad7cadc905d5ad11c1fd6fc8178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b600ee1db91a2fcbf1dc223e4c943bc2010af24ba546c9a6f58b36702cf8346"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d0c38e3ced18c92c54b39e8c275c6e0a460fc0127cd1e9e7745eeaf5b58e831"
    sha256 cellar: :any_skip_relocation, ventura:        "d11da745c086298e7dfa1876440bf3ca8af99b44e0123a6dcef83d2c19619549"
    sha256 cellar: :any_skip_relocation, monterey:       "6a795a583080ac09c9866a8ccc742e2985d11c834ea4164501b33269d70b1dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c34cf469f8007319bfbf08f98f5d1649e00ede21536a7be68ef26447e4475d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")

    http_port = free_port
    grpc_port = free_port

    dtm_pid = fork do
      ENV["HTTP_PORT"] = http_port.to_s
      ENV["GRPC_PORT"] = grpc_port.to_s
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    metrics_output = shell_output("curl -s localhost:#{http_port}/api/metrics")
    assert_match "# HELP dtm_server_info The information of this dtm server.", metrics_output

    all_json = JSON.parse(shell_output("curl -s localhost:#{http_port}/api/dtmsvr/all"))
    assert_equal 0, all_json["next_position"].length
    assert all_json["next_position"].instance_of? String
    assert_equal 0, all_json["transactions"].length
    assert all_json["transactions"].instance_of? Array
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
