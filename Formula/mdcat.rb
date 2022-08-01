class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.28.0.tar.gz"
  sha256 "5d7b4f4b4c1066a679cd171e7d784b4ab8cad37c44d1e1b4250a21683abff9ca"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38bb47f62f60185d96ed8e090b6f8435f5b9c79ad148fc7e32815b92c142a318"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d995836465f508f32369c2591f2bc8eb06cedec04e21e6870424c8d4fde4a42"
    sha256 cellar: :any_skip_relocation, monterey:       "bf08c844a6e00ddf3e9cca6c4c910d03649e5137b89306307177c87c1bddf9a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "549679a1cdc92842720e7c8125c23a3c0f6723ca2ec3f7a0d534442ea93d1a9a"
    sha256 cellar: :any_skip_relocation, catalina:       "c13df2045beb1db28147dae464666c8e135ea5245f535abcc5f3a52284561c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3096ae6e4464396196bcc26b26fd4edffed9f56b435788cbdc0a54caebcd2f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
