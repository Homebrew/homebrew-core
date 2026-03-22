class Hivemind < Formula
  desc "Process manager for Procfile-based applications"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b4f7259663ef5b99906af0d98fe4b964d8f9a4d86a8f5aff30ab8df305d3a996"
  license "MIT"
  head "https://github.com/DarthSim/hivemind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "86b3f4017f9920e1035a4d888d7bcdbb34d99c75ae1f6500570eb099a241aa4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "703f51c01ebed71957e5579c9c753b3090443312b6d6c69a019b0be10a6aa4b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4aff69e5552065591bb76b91c80ee7ea9b072e32b339cf6d7fe658cc8e3d5f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "607a7cc36605a2a8b01952dc7d5755995d57370cefa3ea320c77c893d1cd9e93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ca06b6d2dde91c66cd6af2396a58b40e6be52e51fa738f24ff2e23376dc60a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ca06b6d2dde91c66cd6af2396a58b40e6be52e51fa738f24ff2e23376dc60a"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbbd5d0316e6b88c627c0c06f9e5cffee12b1db773ee32f243c4dbf06e2c452c"
    sha256 cellar: :any_skip_relocation, ventura:        "026944b2be6f616212ad147c3b9ce9bba4a18929f8db3edcee75e2eda6abaa20"
    sha256 cellar: :any_skip_relocation, monterey:       "eaedb2b4739dc4e668ae9bf563750e1bb54fea1f16e800f6bf496226dc1daff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaedb2b4739dc4e668ae9bf563750e1bb54fea1f16e800f6bf496226dc1daff0"
    sha256 cellar: :any_skip_relocation, catalina:       "eaedb2b4739dc4e668ae9bf563750e1bb54fea1f16e800f6bf496226dc1daff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59ded5a99d5aa39ca906ae688d9d57ef5407316329f662f2299ade76cec93e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c702f980c6b3a024c20bd50af65de981ab55b360e10013b22aa6797d834f7c85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    assert_match "test message", shell_output(bin/"hivemind")
  end
end
