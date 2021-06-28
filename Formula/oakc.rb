class Oakc < Formula
  desc "Portable programming language with a compact intermediate representation"
  homepage "https://github.com/adam-mcdaniel/oakc"
  url "https://static.crates.io/crates/oakc/oakc-0.6.1.crate"
  sha256 "1f4a90a3fd5c8ae32cb55c7a38730b6bfcf634f75e6ade0fd51c9db2a2431683"
  license "Apache-2.0"
  head "https://github.com/adam-mcdaniel/oakc.git"

  livecheck do
    url "https://crates.io/api/v1/crates/oakc/versions"
    regex(/"num":\s*"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec93c176be096570af4019c9f3a4d2817431dc42811ccfd53ff45baf21df477a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5eb1751a2156b8fce16bbc88f23f36748bc74422276aab43a8272e71d0d92a34"
    sha256 cellar: :any_skip_relocation, catalina:      "6b79624346a62c0e249e801857fd301f3ce0a72b9557da2dc5e4a56cab12d345"
    sha256 cellar: :any_skip_relocation, mojave:        "80c5b0d77def05e95b5b786a5dc1a16e757fcf772a32b1ee5976fc09583f3312"
  end

  depends_on "rust" => :build

  def install
    system "tar", "--strip-components", "1", "-xzvf", "oakc-#{version}.crate"
    system "cargo", "install", *std_cargo_args
    pkgshare.install "examples"
  end

  test do
    system bin/"oak", "-c", "c", pkgshare/"examples/hello_world.ok"
    assert_equal "Hello world!\n", shell_output("./main")
    assert_match "This file tests Oak's doc subcommand",
                 shell_output("#{bin}/oak doc #{pkgshare}/examples/flags/doc.ok")
  end
end
