class Jshon < Formula
  desc "Parse, read, and create JSON from the shell"
  # Original homepage `http://kmkeen.com/jshon/` is refused to connect
  homepage "https://github.com/keenerd/jshon"
  url "https://github.com/keenerd/jshon/archive/refs/tags/20131105.tar.gz"
  sha256 "28420f6f02c6b762732898692cc0b0795cfe1a59fbfb24e67b80f332cf6d4fa2"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ba745cfbfa0a47f539e46b599633805b202ca8766b1cce5831b49d6bf99ca7bf"
    sha256 cellar: :any,                 arm64_sequoia:  "c71de9488ca461a0438c85645c42ba5e5c8b81c9272c2639c258a5e6b80d5432"
    sha256 cellar: :any,                 arm64_sonoma:   "9f0b7bc5a2120f0ee203a1398bf9f35b45e3ba143adf38a6220c066db09e48f6"
    sha256 cellar: :any,                 arm64_ventura:  "143f521901ed3810e8b535bfe42acdb099026a2560c96a65095d977f5e1bb331"
    sha256 cellar: :any,                 arm64_monterey: "61a74bb42fb52712f535d63e3a7e3f9b0e06c372ce6d4b0c20e07af22d360620"
    sha256 cellar: :any,                 arm64_big_sur:  "cda0d78d58a0f23419cef2718919688bef98ec7461e750e60f9a10dd528c02ff"
    sha256 cellar: :any,                 sonoma:         "5368b1d8cdca07e75d70b448bb6414f62876344d82c8c26c0c5785def3fc0dc0"
    sha256 cellar: :any,                 ventura:        "642bbf1d65f96c69316ce7e0294bb750107912515d47d92417a5482e73ba7e2b"
    sha256 cellar: :any,                 monterey:       "9f42af851267206d434ccbd1765c6bf9044ddcca29682b3a8b88947dbb8f5dab"
    sha256 cellar: :any,                 big_sur:        "301ae5b178d603c79eb0ae2316647ea558c0eaea4331a525a9bc52f6f6387203"
    sha256 cellar: :any,                 catalina:       "ec755371878b6471b6d5fb0dac981f7969dad3a42b9aa2e9be60f7a303b3fffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0afe7df1a37e88dd5f3f54e74c972fb4e8233722b321b6e67f5a0318720fe7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75afb2192ca7b1257b811c27359474bed0d281e1d67eb3fdb86fbf04005563db"
  end

  depends_on "jansson"

  def install
    system "make"
    bin.install "jshon"
    man1.install "jshon.1"
  end

  test do
    (testpath/"test.json").write <<~JSON
      {"a":1,"b":2}
    JSON

    assert_equal "2", pipe_output("#{bin}/jshon -l < test.json").strip
  end
end
