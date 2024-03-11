class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.1.2.tar.gz"
  sha256 "332c8e659a668ceeae70b0d268a46f00bf8bab696dbf7f84faa69b3c509da286"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e5839f4e7255766d5eec2b34e0327ba99f96fe004f6074e424ea2fbfee2d8ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6054cc96e40baeb04488688f4cd06bd5f302c165a9e5cd089e604aa8a7a368b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5185a08b8f2a2861aec6fc52dac92b2cd3321088249e67045073e334a05e59bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "529729434f85ab7738e6377a420e51d6e1681be570ea2e82d4bf58d93a22ec8e"
    sha256 cellar: :any_skip_relocation, ventura:        "837b9f31a6485dab6c977a727f92076a4ace165d4b51eb9c777ff39f72eecae0"
    sha256 cellar: :any_skip_relocation, monterey:       "89ebe6b94f333697f20e802fe535bb1d8e85705b17405a5a278219d8dde45afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f08bb0112ce7c0291f1a9695e25080ba595cc240ba12ecddc224ba96b81cbd"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["target/release/build/mdcat-*/out"].first
    man1.install "#{outdir}/mdcat.1"
    bash_completion.install "#{outdir}/completions/mdcat.bash" => "mdcat"
    fish_completion.install "#{outdir}/completions/mdcat.fish"
    zsh_completion.install "#{outdir}/completions/_mdcat"
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
