class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "78bde2786b395515ae1eaa7d26faa7edfdd6632bfcfcd75bccb6341a18e8798f"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dc95924f84b9554fc485e47cb7001d16bafa4045727053ecb0fa4658d7a42eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28a7b64910b969aa9438a6271e3282db6e279e7989f7421a4dc4fc4dcbfb2b87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b640bb7119770a68671ffe63bbd703484e46da14fda87389744fa15144010fae"
    sha256 cellar: :any_skip_relocation, sonoma:         "521f670f80089750b067117fbd633a0c23cead6d74c13ab2659ca4ea85158097"
    sha256 cellar: :any_skip_relocation, ventura:        "e8dfa7c21003d61c848133b22de35a3d1bfbd0b3b2cb2ca1d2e81c254b406453"
    sha256 cellar: :any_skip_relocation, monterey:       "69df0c18793c1407440aa0bb72f9f78be209363c801a6f36cee1a31599230b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83cf0040682d9e533ea5e676d8391608e855a21116e41ce34f8947c27478da1"
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
    assert_match(%r{(compiled with Erlang/OTP 26)}, shell_output("#{bin}/elixir -v"))
  end
end
