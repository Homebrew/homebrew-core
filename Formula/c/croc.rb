class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.0.11.tar.gz"
  sha256 "09b355bb412d9b5d1b2e0c30b866b9885fe6c4e88f65f6486d1f0233d591e07d"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f80ed0a0c99d0893c0dd61f439067254089caa9c1e83dd1f117794c7ec6f99b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9d0ea504fda3ed9c4b5d42e97bc42a5c6240777bd3e1f3e1913edfaba68a5e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f195b30918ea329fa16beb2fa5128d9141dc95de3c900769ccc3e40dbc2c20e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e7a787909f46cde35a86f3086d0984453bc81fad0502f749fc77a56a9dfb06b"
    sha256 cellar: :any_skip_relocation, ventura:        "e57e4e7eaa429784b8787417e344eb847264c21a698075b3e98ed9ae1596f1c9"
    sha256 cellar: :any_skip_relocation, monterey:       "6024d5ca11d7b7bb5887d267035cc7943fb867619103bad4ea8ae91cee347b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e740077f65f60914fd6d5e16134316487342da779f31f74d687bba680cb426"
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
