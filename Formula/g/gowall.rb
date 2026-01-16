class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "31992b7895211310301ca169bcc98305a1971221aa5d718033be3a45512ca9a4"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "222163cc3152f06d848ac28ba2bab3ec6fd2203987a8f147ac59dbefc4fe692c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d18bb347bb59ae880592fe8e0678832e99380d8a51692664ceb676785589517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb69283e0903f722879f96513a5f4c44b95e4b9a804a07bdc159673bdcafd9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af5bdd065485a4afa557d3a94caae8a1dd30da0207f5d99e20980da29709c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d4b881ff9705718de4b96b63ab15e0f08e1d976b02eb027979760614f53478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10cab58524563fc7d14e63b4f8cb050b7eab22323538027c32a7a01c13feab1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
