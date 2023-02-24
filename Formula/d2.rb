class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d379c6270540e899a84b5ed6667bd02c82c81787ca37eb7d79acbfe00ff1a24d"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db565538feef69f3b15ab4b9c76140b5e85b9b81db4b1e3d6d1ce5b144a64480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8305fcb78ae4135162ca4144fa46d991e1b9d3ebbe4622b1b4e320f313242542"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b3a1a0a505c0205c75bee3bcae0c05ef4defe516191946ad22132d29745138a"
    sha256 cellar: :any_skip_relocation, ventura:        "547e812da08c4f3846c2e20285fb48dfaf91bce0e148c4058d5998d2fcf300aa"
    sha256 cellar: :any_skip_relocation, monterey:       "0cad3bf2e09332924fd2b9eaf98f2279514cfa50bd7f88d33ab08e351406b891"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3223159a5ee059a3d2f31ea11903afdc73ec0013389650a4ffc67ef3b6fbbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc831363f31144001082f1c6546483725aceb9560b1fa92bf8e7a66ba6d5c33a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", test_file
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
