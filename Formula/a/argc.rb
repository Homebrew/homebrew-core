class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "39107b9c1a6055efbd863c4b4372a3b60cee52f50e0983327419d73ec64b91e3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "105e729e79587c8ded0bfbdcf7eee8d06c4751aed16ce365dbc6ea9d4c681bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6096c6ac8d56af83d3e8d7f5cb3518c1615a5aa9cacebbfe3378a405a76ed0ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "151fc65686e9a0c36082e9a56fb6eb6b504afd3d15dc1dd44dd0635572ba86fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f96f6008b8f931557c0a8fff7d3f73e8ffa1c25c85b660ff18267f0cda8eca6"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf785b943f4ff4b55b5a2acc3d1a152f1514a28c3619344cbdaec72fe2a2583"
    sha256 cellar: :any_skip_relocation, monterey:       "1bcf3d7d165bef9555a672e8dcc717eb176f9e83009817d2f545e4bd31425302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5bbdb9627bd11c95efc3bba15bfb0853edc3a04623ddbc582da98f6c011c49"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
