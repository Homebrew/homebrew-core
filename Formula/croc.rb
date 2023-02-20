class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.3.tar.gz"
  sha256 "6b935a30ae90e971676872aa6401065d1ece5bb6d4b7b9e370afe96affb2c5bc"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a5f1b669a36c073f4396c7507c8ccedad4403c5f7e6a1cf515567b2a1f1fd17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97651f5d4397fc76ab020cc5c79a48d263862c09662631ea1fe2328fbbc2047c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4c7dadd90a841293ab04486e34557a63fdef24313e518b9b0c1041cb1501e54"
    sha256 cellar: :any_skip_relocation, ventura:        "8e842c5d3a58205af9d64f2a07dff0188b4305eee913dfd8c6a0357552342fda"
    sha256 cellar: :any_skip_relocation, monterey:       "cb98d0d1fad1f961d25bfa0e286c1b964df28853ce1b07412d9cedfa58e6d029"
    sha256 cellar: :any_skip_relocation, big_sur:        "426651e57e628ccd9f2fed7a5e77c0caebbe37bbe4306aef311d2470f087831c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484a6157f2a11e92e68f99bed72fc09b90946bb614b6341dd655f33ccbfcebd5"
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
