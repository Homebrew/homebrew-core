class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "1d2e04224235247cd98347ac36a84271132934e2b56242ab285b125b3b0bf719"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34a6d8cdc38d5556556c03736afc9b757592bd534efa7cb2530aa77ad46bc5be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c42b51fe5d9c77f4ed797a157a9d97896624d2baddf7db581ebbf6cba8917120"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f80fedbad44366de5ceb911cd52226740330262aa7f372f5ab4832c79f5fcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca8cb492fdf54f47d7df0f6f3220365f171dba0481979ddf3973c2de9c7b1ab"
    sha256 cellar: :any_skip_relocation, ventura:        "8c8b7c527f8e6c4601c46858e7ee06fa5604ea0cbbc649d85759f71ac7085a66"
    sha256 cellar: :any_skip_relocation, monterey:       "76e92a19dc0b007a490f43badc8b468750d2b7ffdbdedc52d5b55bcf3b0128f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55db19f7f09792c345b00423964b3431b6b129a517a08aeb0711326a7cf5949"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
