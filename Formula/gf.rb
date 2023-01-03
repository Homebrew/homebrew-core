class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "fdc21f286ae48ab748378a0d2e4a5a2e980864cefa53605a5d4dfdaed44de478"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f2e7731ca6ad24e8896048529808cc465bf8202ea6d6ce72d8d9c071a232f15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb734f05a918e3d4e32c59bf9644d97eb6c39c744500096cfc5f2984b8a2386"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "660b1864bf64eac8d5bb11c711ac42502795c36b8430ebcb03a280adb4ddfe1b"
    sha256 cellar: :any_skip_relocation, ventura:        "dbed80fe1772274cd76ca3c48ee1844046a9da1bb31c3d298ce0378dafd485f5"
    sha256 cellar: :any_skip_relocation, monterey:       "fc7682c4d83d7b09adcb29095ae03e62ba83e644ed175162f1684ed46d83f160"
    sha256 cellar: :any_skip_relocation, big_sur:        "6550e404b81a5bd3d2b1b70f246e8b1208680b7331a9e31130ed8936822229e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e5968add70f0fb8b8c8d4b66a35df8b0b1a27adc8cfdad2f78bfcdfd0711dd7"
  end

  depends_on "go" => :build

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
