class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://radicle.network/nodes/jardin.jorgearaya.dev/rad:z39RJHSHs166S5kr8Qstj6kd1LFah"
  url "https://jardin.jorgearaya.dev/z39RJHSHs166S5kr8Qstj6kd1LFah.git",
      tag:      "2.5.6",
      revision: "251292f1544bf3c69ae6c8a325beb2930d6509b2"
  license "GPL-3.0-or-later"
  head "https://jardin.jorgearaya.dev/z39RJHSHs166S5kr8Qstj6kd1LFah.git", branch: "master"

  livecheck do
    url "https://jardin.jorgearaya.dev/api/v1/repos/rad%3Az39RJHSHs166S5kr8Qstj6kd1LFah/remotes"
    regex(/v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.filter_map do |item|
        item["refs"]&.keys&.filter_map { |tag| tag[regex, 1] }
      end.flatten
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95781ffbd87f18943ee5e89a71a16f54abf0369714bd772b7a1d82402d99dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95781ffbd87f18943ee5e89a71a16f54abf0369714bd772b7a1d82402d99dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95781ffbd87f18943ee5e89a71a16f54abf0369714bd772b7a1d82402d99dbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a719ca0b44aae13f4f5565da2debd8bd0cad746c24414faed90d5b80331ac950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de795319b932c7e4f5dbb7fb83ac04999120d7a9ab1465b7ac4c0675e85720b0"
    sha256 cellar: :any,                 x86_64_linux:  "3b02ecd13d04763ebebacf077fad9e0fb3bee56d8f1c776a500429ae36ea1545"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/goimapnotify"
  end

  service do
    run [opt_bin/"goimapnotify"]
    keep_alive true
    log_path var/"log/goimapnotify.log"
    error_log_path var/"log/goimapnotify.log"
  end

  test do
    (testpath/"config.yml").write <<~YAML
      configurations:
        - username: test@example.com
    YAML

    output = shell_output("#{bin}/goimapnotify -conf #{testpath}/config.yml 2>&1", 1)
    assert_match "tag #{version}", output
    assert_match "empty or have invalid configuration format", output
  end
end
