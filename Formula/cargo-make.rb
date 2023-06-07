class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.9.tar.gz"
  sha256 "c3e7643f8db93930eaee279d4b6e8f726fbb75ed6c8411b8a042cae5c5f55ffc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb31d113df47374b23444d7a94d616554b4139614fe294021bd4bd9aebda9cd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5895075e336a96a934273031dd0d91119086c9bf316553a30d1d2c182bff75e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be34a9ba87e23b03da095a621b5bb8c99906ca8e386dbd2f9d8922e681b14595"
    sha256 cellar: :any_skip_relocation, ventura:        "68aa2215c113c1f5754189ebbe78b6ede3ac1d42562b2ec97ef4d16fa83d232c"
    sha256 cellar: :any_skip_relocation, monterey:       "16fa0d6bddc7fada7b8e6f9fe71e38bda35c9c3de4d95c02ae71b2739fedf5a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3dc5dd4c8ec7af98af92d6db8fb88d3313370f96d89774c952659dbdf2d04af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1385a4908396444f9d90f784c538fd9aaeaffeaed94eb9a7b67de937491252"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
