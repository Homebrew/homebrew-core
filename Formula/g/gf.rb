class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "c1feed53732c29a75caa1b17a63565b9634159666e091f6c9f8e8b2b4d50c954"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1ec0c309e0cb60f87b9fce280922c4ba6827c94aa9b603c134ab1e1ea774652"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1622f469af570179f6a1fbf841046a38ebfa20b1862cecc4db3933985d30ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd2df86ae66957b46414c0110713329fb50ddafbccd459e0760df414505788e"
    sha256 cellar: :any_skip_relocation, ventura:        "b42db926bec90906437e18b7d82c05bebedfbc6d2307a2cfd69459908c451dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "b95b40de6e07363f05ffe41658951950b59353054e81cb4eaf23e2634d48711c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a68db4171b7809bfd745fdad596cc275fc57c0362f3c721cf3d967150531e019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a483f6790ce7f60114b8d561bab39399a02578955e56ef56f52918a9a4be4704"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args
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
