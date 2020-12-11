class Oakc < Formula
  desc "Portable programming language with a compact intermediate representation"
  homepage "https://github.com/adam-mcdaniel/oakc"
  url "https://static.crates.io/crates/oakc/oakc-0.6.1.crate"
  sha256 "1f4a90a3fd5c8ae32cb55c7a38730b6bfcf634f75e6ade0fd51c9db2a2431683"
  license "Apache-2.0"
  head "https://github.com/adam-mcdaniel/oakc.git"

  livecheck do
    url "https://docs.rs/oakc"
    regex(%r{/oakc/v?(\d+(?:\.\d+)+)/}i)
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
