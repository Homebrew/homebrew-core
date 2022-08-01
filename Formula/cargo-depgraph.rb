class CargoDepgraph < Formula
  desc "Creates dependency graphs for cargo projects"
  homepage "https://sr.ht/~jplatte/cargo-depgraph/"
  url "https://git.sr.ht/~jplatte/cargo-depgraph/archive/v1.2.5.tar.gz"
  sha256 "75e6b716996062518bc556607929abce52dffdd97422275b41079e971f9459e2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2d8c9fb244c7f8b1b83ec485c9e67e5ecb23aa79cd17d06c338c746106c5b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab3f2fae4e4e5cbb9864f4ff250fce0e8d18a6c87e0a74e9afee328c39ed7b30"
    sha256 cellar: :any_skip_relocation, monterey:       "7aba3c49400cc7b7285601deded9016e0c7f02a9994828525c92369dcf040d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cf0a6ca9a2285476b22537b1cd999530c3b1836e9c24675c561baa198840944"
    sha256 cellar: :any_skip_relocation, catalina:       "2be66238e2a2b7e371fcdb2c9ecfa618d3bead843fee26c430692d6061a0e1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d163821cff1fd8f7a09b4be44ae65064ca221bfe1ee6faae6b3ca7f93f6ece83"
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
