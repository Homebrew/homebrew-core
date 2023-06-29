class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.15.0.tar.gz"
  sha256 "0f4df7574a5f300b5c66f54906222cd46dac0df7233ded165bc8e80fd9ffeb7a"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97f7059a6b59901277f15c167d58e0ffc6a027e7d56b60788252344e3f04ab90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54e8e60668e63942fd06322c4d523d671bebddbec608fd3d93715f0ac5a5909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7db65b1386a01b95f7998f4ed5f458e7880a416006b8b7d27848b33dec17a920"
    sha256 cellar: :any_skip_relocation, ventura:        "9078c82557c75398e06ac1de86c5bc0584b3f54950a8cef97a3fb32856207fa4"
    sha256 cellar: :any_skip_relocation, monterey:       "51f8c11baef17fbb285284d9dd234ee5862f53329e3659cc601db6fc028621a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "16a91471c62dee0c720e229dd4575b3060325ac69025f015b4d0f2e6d2a02db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95968579401baab81ccb078aa9b595dfab7ea29bcf71bfc6a9ca3eef80fd697b"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP 25)}, shell_output("#{bin}/elixir -v"))
  end
end
