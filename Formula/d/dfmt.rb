class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.15.2",
      revision: "d8e43e23eca0aa32f064fe7efe8e74a9efa8018e"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5708ab6278be915f769fec47dfedf6545e4ab571ff609c8edca2ddf9a78be996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "06ced6d9e20891ace270b9ae19b99e93ac117d5609ae2f8ec8f222561292ed58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2af58c128ce261ec39dac434a43d3f7247470d53da99f794d878943dec5fc285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef439a3078bc2ee16955a840b26f9262b41d20909ba0e5ee607c3d07e2824c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922bbe6012dbac27a2e65c4d8b1b8e3e7485299005e371035109baed9435fce2"
    sha256 cellar: :any_skip_relocation, sonoma:         "44171bb99b1902f7992a8a2f0bfd3a420f78c4d432cf63e022bdddd0c8f44909"
    sha256 cellar: :any_skip_relocation, ventura:        "a6395124d210dcf1ee14f282d0a1a9a94f46e620e4fbc8fc909197a2c8d49d90"
    sha256 cellar: :any_skip_relocation, monterey:       "67a53f11863df3acfad33a1aa83f7537222e24dfe4b3bd7b64734dffe66ad612"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ac545940bdfc91af6fc839d51f00e8e27f874a712fc1a464c1e68866349eca70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c388fa11efd8c658e529ec9279a87930751226248893b198de70abd6fbcfdc07"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dfmt"
    bash_completion.install "bash-completion/completions/dfmt"
  end

  test do
    (testpath/"test.d").write <<~D
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    D

    expected = <<~D
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    D

    system bin/"dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
