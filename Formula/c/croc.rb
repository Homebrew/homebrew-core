class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v9.6.14.tar.gz"
  sha256 "c8b1a109fcf496a103b8d70ef76c0ace6ef22d5575be6bbe2f571c6b1fe6a8ac"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "641b16579e55de1f8cca1b69bfbc227b1ae64f220e637b218196bc2afc20f48e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d61db4fdd22bd5a4258f150261df1d960374bb18fb30dae0c4013b51ade058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae282db3d380cfc8c891a59ab698087fb3a964ff300f4c0724e212b5d58945c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "43e6a85e9142dda4b7738b0b10a970fe93917eec8e3910944447de2845239bc9"
    sha256 cellar: :any_skip_relocation, ventura:        "32f1828df2f6653afd03bc45b9876dd4ea397fd38cc6f5f392ff68b4657b0f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "1ee527bc6a5fd7c8b1c035ea5b705e3519db0f5e443f581fc465e28c321c3073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b70c87c0deaeafb8605992d95659f7df22df74ff31ed8683e20f878aa63caee"
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
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
