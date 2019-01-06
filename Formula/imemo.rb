# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Imemo < Formula
  desc "save memo easily on terminal."
  url "https://github.com/kcwebapply/imemo/archive/1.2.0.tar.gz"
  homepage "https://github.com/kcwebapply/imemo"
  sha256 "fe443ab343e7f335dfa05b772512bc75c303812f43ba7795d7ed1b6a8ca15e70"
  # depends_on "cmake" => :build
  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    print buildpath
    ENV["GOPATH"] = buildpath
    imemo_path = buildpath/"src/github.com/kcwebapply/imemo/"
    imemo_path.install buildpath.children

    cd imemo_path do
      system "go", "get", "github.com/BurntSushi/toml"
      system "go", "get", "github.com/codegangsta/cli"
      system "dep", "ensure"
      system "go", "build"
      bin.install "imemo"
    end
  end

  test do
    assert_match "memo saved!", shell_output("#{bin}/imemo save \"learning math\" ")
    assert_match "1 learning math", shell_output("#{bin}/imemo all ")
    assert_match "", shell_output("#{bin}/imemo delete 1")
    assert_match "", shell_output("#{bin}/imemo all ")
  end
end
