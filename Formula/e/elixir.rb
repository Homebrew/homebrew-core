class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "385fc1958bcf9023a748acf8c42179a0c6123c89744396840bdcd661ee130177"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d252adeb4c697e2ead90781d7cca7d29f552b4e90862dcb27079b2683d77a47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1486d4cce83f27c6d64982efdf5085972d420a5644063f1e23e2a7115b5cc319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20a69f5b3e458ef8fd93b619ff49a0ce33b7edbf612a356cbda8adfcb699490a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "592f380dff7dd7dba6dc2e403559e30fd15e3f5121550cdf5ea255f6bca4e3ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "72990775fe8c4c1b76522949005aff887e8fd069cdef2b96635da624b868b624"
    sha256 cellar: :any_skip_relocation, ventura:        "69c5fbe184cf3811d11dfe09c1fd2fa517661e24294dd9924bcef84abc34fadc"
    sha256 cellar: :any_skip_relocation, monterey:       "30268d8e7d009a5c29cac3a5c591381ea98094d08d477653a7f299c76f4dc47c"
    sha256 cellar: :any_skip_relocation, big_sur:        "15627c0d3d2de4ebf26121bf0db2fad5c69dafc92ae79ce625b8c410aaab26cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "943e0fda442d6250405b60f5b0a94cfd34049a290e3692c274a58dfd04b43f49"
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
