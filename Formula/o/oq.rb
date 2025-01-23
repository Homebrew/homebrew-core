class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "66b2d879b6e2061121c50b8e584ce82f95fe79348bf3696ca38e5910a6c42495"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3c85406e1243e64b72d6c6e29e57312acdf1da6bf5ad3bd0ad0103fcd6d5ae9f"
    sha256 cellar: :any,                 arm64_sonoma:   "99fc2a852c9fcd9346ab49b10a2fffca37b96c874311073bde9875b1317dcaa3"
    sha256 cellar: :any,                 arm64_ventura:  "79c06b62ee8b7a819e2c752656a17e24192206454206a8f13f23f69764b35b72"
    sha256 cellar: :any,                 arm64_monterey: "86d0284e415fa4dcf91a75c6c5dab04e73044c161777fb52449c62a62c4b3c4b"
    sha256 cellar: :any,                 sonoma:         "d7b699f030dc0c632c034b5ffefb4db85a34976919ee4853e1814cd9caf93a5d"
    sha256 cellar: :any,                 ventura:        "d55554139463e1d576a3c240c55fb868a7520f87073383baa74a9dc2a0769fb0"
    sha256 cellar: :any,                 monterey:       "1ab1903afd02e46a04c19996dab38cfb49051d023a0138bb079b725d29df5c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6875c56c9a0b5c7f0bb103c94bc6e4a0b770f48ec90e46dc58f72e54bc71811e"
  end

  depends_on "crystal" => :build

  depends_on "bdw-gc"
  depends_on "jq"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/oq"
    bin.install "./bin/oq"
  end

  test do
    assert_equal(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root><foo>1</foo><bar>2</bar></root>\n",
      pipe_output("#{bin}/oq -o xml --indent 0 .", '{"foo":1, "bar":2}'),
    )
    assert_equal "{\"age\":12}\n", pipe_output("#{bin}/oq -i yaml -c .", "---\nage: 12")
  end
end
