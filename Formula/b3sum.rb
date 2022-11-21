class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.2.tar.gz"
  sha256 "31c1033009c55fdacafc87e0aaecf9e136fed3ccec6c637ed2461e487240b7da"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1843d201707fe784e33385cc4aefb45377987e31292962113760232f72ccf09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f87ee5aceb949f22b8adc0332a2c8d523ca8b59b0077cc15261d997b5bd9cb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2efa55bc031dc8d76ebcf012ba51249a00ab185e5e02b416dce5d6ab802c9396"
    sha256 cellar: :any_skip_relocation, monterey:       "1eeb03b13cd230d84f99a2ae33707f7ad6b996b19d9e104d3a35e71d3295c6e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd68ffc181d7ec419e97eb50ef64b6b86cb43474c105634b3505fb88bd296417"
    sha256 cellar: :any_skip_relocation, catalina:       "9900dcf4968efefb26422158218b23b58017433110d7199d1917247f799eb5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1028432ed6762a43f2792b19bbf4943fb958b1cabf814354728d98f9de9af3cd"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
