class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.6.tar.gz"
  sha256 "7b70ea161a1d6343b4499c81280d9650fadb1c298d3be96bbc54a2e8d8cd0c21"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "186e48133593bb05d6b62ed6e870b989942cb5024fe590551613063ab5a318bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "803894f1d8a2ee996080a93e320227af6ecaf7bd3b96c6b64780df4a181775d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fceeb48f79a1f677abc21fc48df453454c4141185d3bfe71f2532bf52c2cda2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fee9a55ae1167660f6b5f5697a4cd6e06f1cc8c2fee8e10f866bdc58f4cd8687"
    sha256 cellar: :any,                 x86_64_linux:      "5debbd781012298e515477270bea6438674556fa670004a9e4b50f0f9faf8557"
  end

  depends_on "go" => :build

  # `test do` block runs a local relay
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    ports = [free_port, free_port]

    require "pty"
    pid = PTY.spawn(bin/"croc", "relay", "--ports", ports.join(",")).last
    sleep 3

    pid_send = PTY.spawn(bin/"croc", "--relay=localhost:#{ports.first}", "send",
                                     "--no-local", "--text=mytext", "--transfers=1").last
    sleep 3

    output = shell_output("#{bin}/croc --relay localhost:#{ports.first} --overwrite --yes")
    assert_match "mytext", output
  ensure
    Process.kill("TERM", pid_send)
    Process.kill("TERM", pid)
    Process.wait(pid_send)
    Process.wait(pid)
  end
end
