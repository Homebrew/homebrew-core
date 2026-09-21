class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://garden-rs.gitlab.io"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "40f7df483e784583664e258c6d27873050107d6a2a80f971ea64264baf89f0b5"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcf9f03d59448c0dffe48e55bb0b565220e6a7a47abc5eef10c4646bd61c85c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02ca0b134297c502d53e7a2e78cc251a9c12d0e22c690c2a2efbe382d9315c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c89f4e44b6b4520c1fa7094aaabcc913d381a44a800af5f006d935498264529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "68620c1ae9726b2d6f3ca1429326e934f843fa9fc45460b2606b3566ecb8fb2d"
    sha256 cellar: :any,                 arm64_linux:       "30c787ab704fe617a640cd2e86beb4c03c2b214edf8b26f346ab7e4c1f90c117"
    sha256 cellar: :any,                 x86_64_linux:      "2edfdda9ee1a547957b085e031de75a8f9205b97cad67ea13458745b08dd8ed4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "gui")
  end

  test do
    (testpath/"garden.yaml").write <<~YAML
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    YAML
    system bin/"garden", "-vv", "test", "current"
    assert_path_exists testpath/"current"
    assert_path_exists testpath/"output"
  end
end
