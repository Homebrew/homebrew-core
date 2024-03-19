class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v1.0.1",
      revision: "699fd6acaecaa99179bb02bb13161fc8f1f05cfa"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1625e3f6125797bca38d90f568fd856b5987dde12bf6e84b8a60e33e8491266f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc3afbc24b1f00c34c0fc104cb3bf267aeea50f73146e4d37d9d5f51a1c43a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b037461f849694ff907a549d93d3528e3388955cfae09c487ac722ed8083519c"
    sha256 cellar: :any_skip_relocation, sonoma:         "05b45e9f7025afba9845fea5478bd40b0dbdf42f5ded74dc80c9d22b4a81cfb9"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc36c4cdd0e610abd90aa184a407be54dd53d8cd4b37ad53fe6bd5140f3800b"
    sha256 cellar: :any_skip_relocation, monterey:       "dab34d0139427833790d9b2cb04f42ee5ede191368d9d694a2d2b8f683d47ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd3701402c5aef3da2be69b1de975ac2619a199697fa63c9a346f06f270803a"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "jq"

  uses_from_macos "expect" => :test

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'

    (testpath/"ijq.exp").write <<~EOS
      #!/usr/bin/expect -f
      proc succeed {} {
        puts success
        exit 0
      }
      proc fail {} {
        puts failure
        exit 1
      }
      set timeout 5
      spawn ijq -H '' -M -n -f filterfile.jq
      expect {
        barbazfoo   succeed
        timeout     fail
      }
    EOS
    system "expect", "-f", "ijq.exp"
  end
end
