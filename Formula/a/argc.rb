class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "b073e531baad204abf432b53c4f94633c80a791337f141d2daba96fe58d81af8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406229470a3119b585dd79be1641eb76728a7798b1c2ac99c9665002ef8991ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab377dc8d4d29efc0e8cc6b31b9dcc68d75eb8675b2874203655d29988f76726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1cb6bcf3f4fc8e1605a0a0168540c1c479e74438fb7ce06042d03c95db13513"
    sha256 cellar: :any_skip_relocation, sonoma:        "1082016dc1b5cd67f53e9f0f8d229af480589ebee30cfaf39ed60356b4d9a53b"
    sha256 cellar: :any_skip_relocation, ventura:       "3703333faaf342d97acfbbb967b2c200ef04596e067ed11073d7bdbc82084140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d3ef416c74007a1b825942b6e49506cbcd02f5d72fee60c1eab75e63b8c3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca825947ca8c6727d761495478f176069057a41ce6a8cae4a3de3bb279fd73a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_path_exists testpath/"Argcfile.sh"
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
