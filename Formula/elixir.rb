class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.0.tar.gz"
  sha256 "ac129e266a1e04cdc389551843ec3dbdf36086bb2174d3d7e7936e820735003b"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18301739c2d532906881333d0f0c4a1435cd7f928774514fe2f74a07a8ea5ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bfc7700ab8b3940c8f3a64305e66b9eae45836f905f54adf32af1e57baecbba"
    sha256 cellar: :any_skip_relocation, monterey:       "98449564d88814d1c5520dcee22ac106d8bc0b2656f18b566b7f1bd791ad54e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "667216b6efffc119f51a161ec71ff7bd85a52166786a653c5717749ba9db042f"
    sha256 cellar: :any_skip_relocation, catalina:       "79f0d91769a100fcd667ea8b5a64a99698191483cccc98efe1bf85aee4bf3488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f963206774ba8f59448dfd20d8bbe33504a8f4249cbf0b2e756ac66bdbb587"
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
