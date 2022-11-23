class CargoDepgraph < Formula
  desc "Creates dependency graphs for cargo projects"
  homepage "https://sr.ht/~jplatte/cargo-depgraph/"
  url "https://git.sr.ht/~jplatte/cargo-depgraph/archive/v1.4.0.tar.gz"
  sha256 "c138718e610673352b99d7078eda46f6039c3e20d44f85e4312d48d9dce99f77"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33e209e756b59302bc36f92202ec077d812f9abdec5c610d9bfbd91b678cc387"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccfb5ab1e99e85d17858b691c665ba94f81758d5e9fa3cc3695b21e201091f02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee7f12184065ff5755a97ed5c1e453cf0c53838b1c443060bc37f331c3b81051"
    sha256 cellar: :any_skip_relocation, monterey:       "2230b3d2052e8b96b3d555173b35a3857b521f2427d25d732760aace182f78f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cffdec29ce038804a317feec80526f53b0fa5fc594b3cc3c3ece57762e033623"
    sha256 cellar: :any_skip_relocation, catalina:       "d05be720b3bd9af933abb84c78f8625fb4822e6428557e36a19a6a1861b3dbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3518a7af0012d9955fda4d3a7f79ffbbbb8a75a0f05c73962d3502551de6ddc6"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        rustc-std-workspace-core = "1.0.0" # explicitly empty crate for testing
      EOS
      expected = <<~EOS
        digraph {
            0 [ label = "demo-crate" shape = box]
            1 [ label = "rustc-std-workspace-core" ]
            0 -> 1 [ ]
        }

      EOS
      output = shell_output("#{bin}/cargo-depgraph depgraph")
      assert_equal expected, output
    end
  end
end
