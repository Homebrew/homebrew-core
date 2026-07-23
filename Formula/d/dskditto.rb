class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "66732c8727a514d69ef6290df8a78ce249ce54dcabdcc43439ede902c4e1b0c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb274bfaaab2c4ad140f511a9a486665699d26eac5e0ffef1463b9b3a6cdea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5fe9522c277ff305fdeed39517b8e64aee75cc83a78d52fd24c63c2528c7e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38855948e1f3567655bf46c6357409d9f5683aa782eabb7bfc8802f96394597e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cdc1d5709e0dd3c0cdd8a977d9a60fc4dbe860d510a4fc879bfff66e0059d28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e493616a32ab0a323ab33978674cfb5e052ddc4188a099237f996eea585b9f3a"
    sha256 cellar: :any,                 x86_64_linux:  "fe2cfd5a0c8ba3d3e124c8be841ce1b96a078531f6b3255453719c6616cd23cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jdefrancesco/dskDitto/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dskDitto"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dskditto --version")
    assert_match "GUI support was not built", shell_output("#{bin}/dskditto --gui #{testpath} 2>&1", 1)

    (testpath/"a.txt").write "This is a test"
    (testpath/"b.txt").write "This is another test"
    cp testpath/"a.txt", testpath/"c.txt"
    output = shell_output("#{bin}/dskditto --remove 1 #{testpath}")
    assert_match "Removed 1 duplicate", output
    assert_equal 1, [testpath/"a.txt", testpath/"c.txt"].count(&:exist?)
    assert_path_exists testpath/"b.txt"
  end
end
