class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "558f89cd39458bed1f945d87ad320e5d8f337fa9e627a8479aaefa0494a06ea7"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55ac5d951ec6364e0974063ccbe6d37553adca894cf3537fcec52fa856fdd6e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "055199d9182f20240f0fc43c26630e928718d60f72f5219d6326fc027579c440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f49057a30dc980a64a7c33e9095b294063c6bd3e39cf0ad98a47ada230fdc93"
    sha256 cellar: :any_skip_relocation, sonoma:         "e99bbd5ec3fc456661e07c6d1e537ae57a219ad02df3ae5ab4fa5c002d2609d3"
    sha256 cellar: :any_skip_relocation, ventura:        "fab1834ff623e3e0dffec8603392482c444a868bb5cf8b2d39015aac89997b81"
    sha256 cellar: :any_skip_relocation, monterey:       "0f5aaad6a70f5e4da2ba82afa20944641c785421db2a22132523b15c7ce6199b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4bc44ec982208e28059bad9c1a84545bc9e23314e5493522a230e23b819ad96"
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
