class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.15.tar.gz"
  sha256 "ca118155cdf3ceb7496928b1c76387ba74f39b774372d30543e6cbd23d2c0a97"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6e7cd5f01893567ade07728525562bc82169df3726ef6b00dc559f868c1dbad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59370de024a5301e8f66bddb247c9775e03554fe0bd5a629990bd665c97c65f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6fcd5a24500c927a692141be69e8e7c4f0dd584deeb152367114708b3748afc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2466517bcc89f8465b01cd2437d4d0be116cde6459f48599e915fd4ac78cc93"
    sha256 cellar: :any_skip_relocation, ventura:        "44d29b9d33ed7b909730d6523fbbb38924b11e85f4cdf4b881f8c87e5cef7cca"
    sha256 cellar: :any_skip_relocation, monterey:       "b359184b91e95b4a3ad7c4feae77b0de183daeefaf1671b7ca1ff25490ad6b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65b2f6f2b44197a0ba60c528d369773b2457d66edfa6cee33cc7382c885a5b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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
