class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "40d334016d06a9f471220f8369815d2ce086e151ca3638ded9babbc94efe19bc"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d99102496aea473a2903b5633cdece9b8b31f0ce1c7a20c670a7c11335f2477b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4da4de030385764cf1e1c04601b3b9cdc2063dae015caf7be12afe0ce2503c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "725371b96cbf84184183156113426746a16e8492e28bdbf9028e01ff6a4f5ef2"
    sha256 cellar: :any_skip_relocation, sonoma:         "adfc1027952572bc3b066c294ffe73ca3915d8b723b06c6cd5075e6b0e648145"
    sha256 cellar: :any_skip_relocation, ventura:        "c2eb066f7e901a0642b57c6dd3fe276af14755691910dc2a15a7c3ee56c381b6"
    sha256 cellar: :any_skip_relocation, monterey:       "8a875b21371011824842bc8cd5baf6714ed701bf542afc3c64de1cb419fdba6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5064e58ababfb2b27950c370d8244045d7c32940568f8a360c2c90866aa48f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
