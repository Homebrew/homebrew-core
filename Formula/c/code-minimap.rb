class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "0526a15a53a0612963f5d35f74d8381c13c7a9fe49272a289e7237f9ad8879ab"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c95b88156ddabc40410cd962ea71b863821031a3dd4891ca1c5eef6e813fae7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9816768b8c2dc942feb545b95545d470be414489bcfda073746043f4ba47fd2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a1adcfc4d38038e0acb0c5263bcbae8deafed229d1bf43cb7c98ba47294343"
    sha256 cellar: :any_skip_relocation, sonoma:         "b247429db31d2ba7e947d5307771c9d3e467274ba371d38021a4771282e00283"
    sha256 cellar: :any_skip_relocation, ventura:        "e9ef20938bf77720713d45cdf01a6a606fbef93348afce61ab574fe48f6491d1"
    sha256 cellar: :any_skip_relocation, monterey:       "66a429374419e84a17362f0dcd8396e770d1993e34dfb02673648f2d5c670d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edca5e766a5921d5da93ccb541885e25c607b98c01093c6565fa9394f050aa94"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/code-minimap.bash"
    fish_completion.install "completions/fish/code-minimap.fish"
    zsh_completion.install  "completions/zsh/_code-minimap"
  end

  test do
    (testpath/"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}/code-minimap #{testpath}/test.txt")
  end
end
