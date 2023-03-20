class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.3.tar.gz"
  sha256 "bd464145257f36bd64f7ba8bed93b6499c50571b415c491b20267d27d7035707"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "610af16d19faccbe2ceb01aa6003a0d5267967602ec831a88f2ef650474750f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91559a7a5e28a5416c0b13d0c13638257b807dcfa67361fb9118df3de6866ab2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09fd7722ac5f72a3a006d0d4d0676ec13e90b136e4c606e2da1cf8bcf9b27842"
    sha256 cellar: :any_skip_relocation, ventura:        "a42564f0a3a0b750b44058e8ad9dcde29fbf67e690ea919e704767afa9d7fc41"
    sha256 cellar: :any_skip_relocation, monterey:       "16915c5b3cc8ed81fb59a383c1892229448748e3451e94230cfc7301c8bf20c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "76249a7142ec9ca2d171ad82faac3f468bfc95cb9bbcf2a27458a9cb3f8f19ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6181457efa0de2642794679e8a090b1fae9da0df6064668dc6b3166ec3963888"
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
