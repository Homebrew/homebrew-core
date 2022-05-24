class Oakc < Formula
  desc "Portable programming language with a compact intermediate representation"
  homepage "https://github.com/adam-mcdaniel/oakc"
  url "https://static.crates.io/crates/oakc/oakc-0.6.1.crate"
  sha256 "1f4a90a3fd5c8ae32cb55c7a38730b6bfcf634f75e6ade0fd51c9db2a2431683"
  license "Apache-2.0"
  head "https://github.com/adam-mcdaniel/oakc.git", branch: "develop"

  livecheck do
    url "https://crates.io/api/v1/crates/oakc/versions"
    regex(/"num":\s*"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3840062a2c8333fd493e289ee82feb0f92b3806ecf39d81f2eb1088e6df2c82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b58035324817fb113cf2ed484deb7a994e0b1e0bacf8e685220944ed0aa8a35a"
    sha256 cellar: :any_skip_relocation, monterey:       "f782f12b1cc552fff3db6bf157b5f4b02cfab7261254cf8e186f5f2e26adee8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a42a5da5666621bcaedf03d27e569bd7089aca6d35823075cf02abe49d168a19"
    sha256 cellar: :any_skip_relocation, catalina:       "d70a881ba63259365ca41b80ce29d36a7761f5af31ba92eba0f47d21bece3f3a"
    sha256 cellar: :any_skip_relocation, mojave:         "ddce9bc14e1b7067e2bf562b986e813186a448c7fbb245cb34a7867fd6a8ba30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb8902e208888e58db0f0d784bdce232af126b2e8e91dca3f86d7ea068b078b"
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
