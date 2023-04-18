class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.0.1.tar.gz"
  sha256 "d6da2edaeaeec646eebeda13de6ae8a5185f0257342b48740b3f40c7b20b5c96"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8959c97f42169414f032b588abc3a052b13f026eec769a40be56094872f840e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee38c67c2c57a111a3a2a1792385262440990fb2caf8149db7aac3f51419660f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c43bdeaee8ead140c1a3263b1f5c6a37431395245d8b81a2d1eb007257be3444"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6b179d738854447a6316b890002f71d89a24710323ba810acc5669d2bd9e20"
    sha256 cellar: :any_skip_relocation, monterey:       "44ded916e4343838ff5884ca512d35a55bcc8b0972125769470c49cb013ba91f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbf348489099049bb4d9d4d7d4f9411b8a3318be445256994f5a74901503e472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83acac87081bb0ab213191cbd9382af4dcf06c71c78f922c7b3b7cd4a67910d3"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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
