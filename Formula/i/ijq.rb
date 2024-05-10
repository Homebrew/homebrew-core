class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v1.1.0",
      revision: "1e8e0a3b1b29050e6c561d4e95cffd46e767d20d"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a87747a3e03f68f164b95c687f58431de8b3fed1f468bb7f23fec3f8b970a74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "208f40e90ce5a309c804a48de9077ce0b9eede68619bf15c4375b5dfc20324c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "947d459fc3c4bb273b941c664761404171aa5e42a2ea7cf41e48666d7d1b1bf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "45aaed110eb62830579df79ca36727d69aca012c44d3b39db9c67add37a560ce"
    sha256 cellar: :any_skip_relocation, ventura:        "bf87f93a4861773d0abe2c74fc046003a791043c8e18251d5c4e176cce17c6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "e66417e4dd466c9a11ade4e7baeb6d998ce71a66454cc094331d8f7e128dc0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "defbf6204dc865a4a255ddb05d72bc72c853257775723a8eb2f823ec72061bca"
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
