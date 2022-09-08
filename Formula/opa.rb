class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.44.0.tar.gz"
  sha256 "277745ca4328671791ec3fc37bf16b4e270c4057c9a43eefdf855986c364dc9a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eca6e6fc51261b0ca03d69cffb24ffa03f04a4c13e83dbc4e8054dd9b4e21347"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f453bef39813f52f5a442748ac2b98ebcffcf122aea26015542a8245fb57ec"
    sha256 cellar: :any_skip_relocation, monterey:       "1538c6684b7d44f20dbecb7a1cccc9ba6bbce4750741fa251105ea1268870cf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e07e4a8d51cc0fc738f6a4ac48f5998d42db5bb1fa49d1ceea1486a4f45e3be"
    sha256 cellar: :any_skip_relocation, catalina:       "f19a6f6aa586c871462a5a4493b8c0eec14eeeb0514fd3b1543299071e152e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e0ba6af031487d4526b2e38abc151a716bcf0dec9fe5fd63f2558831dcd220"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
