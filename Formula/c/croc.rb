class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.2.4.tar.gz"
  sha256 "c259c07b9da3ea39726b0c5e3f78ae66e858e1379bdb11bef93d31298e68f5fe"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ec2c69c8aaeeb66158ddf2e9d2578c2cd2c49964a8ed2f6dba43acf9605035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4f00c712de947ee916bc39f63db45656dac8788d560661ca721cb52bcf6adcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f00c712de947ee916bc39f63db45656dac8788d560661ca721cb52bcf6adcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4f00c712de947ee916bc39f63db45656dac8788d560661ca721cb52bcf6adcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c73f8051b0b19f4d4815144ebb865cecd84214e0012b0f5bab43723a52412d"
    sha256 cellar: :any_skip_relocation, ventura:       "19c73f8051b0b19f4d4815144ebb865cecd84214e0012b0f5bab43723a52412d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e46c275e52cc8c823e874cb8ddbab289b315321284a5f40ad70f82dc83bf1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
