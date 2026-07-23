class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-1.8.2.tar.gz"
  sha256 "71b8d6e8f5fe81f6c6d0d110e3892251f6ce76ed095abd315e26e6e1193af3af"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6ec821177b4c55fefb4c58f8e6f5d8386a5fce0a3c5d8811c4d6a0cc818dead"
    sha256 cellar: :any, arm64_sequoia: "29c079abc7e165583b7fc4d3feba7a21a12160a414a7d4202731f7ffa2e349de"
    sha256 cellar: :any, arm64_sonoma:  "c5710de7fe77793fda8d4c550e5450b9fd77f9caf4a90c01be3a0969a8c078e8"
    sha256 cellar: :any, sonoma:        "0a471afde49b03dd7a8a1100c2581dc35ae49b3877a9c37fa219aeccdb998154"
    sha256 cellar: :any, arm64_linux:   "30137e8a68ffb92bc8e16494f1509f0c08b404cae8a0842e15b63f46e4baf028"
    sha256 cellar: :any, x86_64_linux:  "c3e26f0bff91db3e6606c3fc23ebe5dc2b1e9854252e6e4a3e03b17f7a3cde4e"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
