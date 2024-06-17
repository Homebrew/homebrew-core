class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.0.8.tar.gz"
  sha256 "9dde7d5114b4466a7351f9117e5ffc0b2866e5dae5d094bd1bc65c83787528c1"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94cd9d6bb7e6e5d8ce7957e8489503eb30fb551657351202813f35e99e8ec565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6464db4661d51d7796614dd8231f97d5d72d4ee3e7ba925f186d69249f11c629"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f784def8fc0f0a4a501ed9120a0050450ec82a268818a9dd53986d75250df2"
    sha256 cellar: :any_skip_relocation, sonoma:         "32fc4fb3a0f39f4f48a840de1a8db1f2e9a646e43f7d1c0834addd42d21d1d7e"
    sha256 cellar: :any_skip_relocation, ventura:        "2ebd22a571a951ced295d7ee0d3e07512eaad282455af23881381a398a920f52"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7956e2ab8163264a6213b06dc4271ce2f320775e4edddf2bce84a0a363ce36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce55fc88d3a97b13d351441b6553d187851d686f44021e972515ad5d8c19842f"
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
