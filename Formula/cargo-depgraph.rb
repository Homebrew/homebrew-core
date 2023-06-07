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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbb2ee6d64ccb54daaeee22d72abe7c80718bbadf12413cadc6e5bf2ac19266"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae25390e1c611870f71d9589bc42ebf4291255f92945a60f83a26dd57b0b7399"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b1d4deaf4e1aecba7d62979378c047d7858fcb086585e0efd210c04bdd0cfd1"
    sha256 cellar: :any_skip_relocation, ventura:        "6139e89e66e1ab0cc7ba72a3fddfb1a04358a830e9a7ff37ddf3a1031f96cb9b"
    sha256 cellar: :any_skip_relocation, monterey:       "02488af08391c6c57695a2b44ec7d878c2641b1d13f7e601f8e1687a5598a445"
    sha256 cellar: :any_skip_relocation, big_sur:        "85e7faf97f187ae2dfe07cbbb70131c00553a3240ae6fb63813269e06a0ae0ea"
    sha256 cellar: :any_skip_relocation, catalina:       "838d8909e653cab5582b38e9ce2b5d599d8c175047cf3835b09bf766f18ad1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39819247ae48a1dcb3adc95890d683915c89166d8b305bd122adfbe6ed0c0934"
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
