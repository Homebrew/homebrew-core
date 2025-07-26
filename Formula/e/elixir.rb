class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "8e136c0a92160cdad8daa74560e0e9c6810486bd232fbce1709d40fcc426b5e0"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb2d0bae633f9e674d7aded654f74e3c49023009f0035993ad3f19f24924c93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3293088a1d6b1fe5c8b629d713747c54591c2f9cb7eb64dfe68a5d124bc7d25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f02081211f774556347ea703f1b8b5a50f1714c0791fa4b760037aaccc0a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c07cc07781765d4972ce8c5ed95eaf01d0c8eda4bb60b5c85304b589d8dea59"
    sha256 cellar: :any_skip_relocation, ventura:       "8330f6eb382b59e9a644369e9a176cdfa573373cca26f95f752adc9e128f2781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db6e83306b5766778262622896437dcb5578d83e8d1c8b6c8daecac887e2cba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d20440fd271698c9f737a0a8fecde327f0a737abb600facc1f104b3c6f566a77"
  end

  depends_on "erlang@27"

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{libexec}", "install"
    (libexec/"bin").each_child do |f|
      (bin/f.basename).write_env_script f, PATH: "#{Formula["erlang@27"].opt_bin}:$PATH"
    end
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end
