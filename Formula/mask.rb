class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/v0.11.2.tar.gz"
  sha256 "abe5fddc7ea1a1ffab59c8f0823a95c7a6fdcfe86749f816b06d7690319d56aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c80321512808c157aa739263f16ac6497a0488c587b84abeb5690831a0ff8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43388f2bac72ba6c337e96acb1a9257177e97eb807bec15d1f62106a402c5ba0"
    sha256 cellar: :any_skip_relocation, monterey:       "07d3bab6e155d245ac877c361093f3c109ae86b510daa4d9ede2393883b5219d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d05edf78de9bba766f6283b2c9746cd356ffed037b35b4fc20e55e8660e6c18"
    sha256 cellar: :any_skip_relocation, catalina:       "8d394f2f60f398dd483c33b30213f75525ea7e7e22cfd41ba7b0b027e835f42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5edff1c56e8cf96f9b89323cf02883f41a9048b9c05867c900dc177268f35a14"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
