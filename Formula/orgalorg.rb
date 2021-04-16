class Orgalorg < Formula
  desc "Parallel SSH commands executioner and file synchronization tool"
  homepage "https://github.com/reconquest/orgalorg"
  url "https://github.com/reconquest/orgalorg.git",
      tag:      "1.0.1",
      revision: "7ccd02c521f79e04720aa929e21715d46668162f"
  license "MIT"
  head "https://github.com/reconquest/orgalorg.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb6b1f905b621322ab83f1517ac65c88e34de880c66049829faea18bd228128a"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec490bdeb7b6dddc4d38abb305b768c5b84ea4ec4af13765cb08a4f1476e20dc"
    sha256 cellar: :any_skip_relocation, catalina:      "6c835354a9fcffa0207c4826f40dacc0cead942e1a364c70a632008803ab2201"
    sha256 cellar: :any_skip_relocation, mojave:        "fe684a04e1e0b0344d1268e68a7cca2af12ea6fdb633dd44524f8eef6a4800ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=mod", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orgalorg --version")
    assert_match "orgalorg - files synchronization on many hosts.", shell_output("#{bin}/orgalorg --help")

    port = free_port
    output = shell_output("#{bin}/orgalorg -u tester --host=127.0.0.1:#{port} -C uptime 2>&1", 1)
    assert_match("connecting to cluster failed", output)
    assert_match("dial tcp 127.0.0.1:#{port}: connect: connection refused", output)
    assert_match("can't connect to address: [tester@127.0.0.1:#{port}]", output)
  end
end
