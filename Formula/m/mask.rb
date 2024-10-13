class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/refs/tags/mask/0.11.4.tar.gz"
  sha256 "65ac7b5798bc717a2a0c3fb933afab45fc901eeb3ff299e03695bf3204d4f37a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da8ec827f9c4e4a9bb05520c5f470735a68a9672203c1541bc728c7f5e3058e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29996fe7c9a55113236922e147d0506b1bd62135de358c27ddbc28264c67b411"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "093e6b2d8c81b38993f1a0adf1eab5315160e4219ba57ea1801097404b24e185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9348d765d00ad6f6d6d41352037293007c5cdfdc0770cd7c806ec7913d266b64"
    sha256 cellar: :any_skip_relocation, sonoma:         "c52f67403061b48760face6e1f93d8a4ed4b4e462e902e1e6f9777f71c25b672"
    sha256 cellar: :any_skip_relocation, ventura:        "9137a95213ee270038a2fce8209c06a668cee93c908491db18b3f344a4609f11"
    sha256 cellar: :any_skip_relocation, monterey:       "dff277af5a41561e20ed003d5a66d5c23465b7a6efa245ed08de294ee82b9f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6b916e73ce9278b65ff01cbb5d89180c5cad3f3a33677ed3b24c896111c182"
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
