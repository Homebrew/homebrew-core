class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "5af111718346a3e16d04f8f7461d089543f0f57c4abf39969b47dad648834144"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf741d36373173c5b368e8cb2b10fd04eec6188cc8abae41b902204d4bc8a122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a485c895fed104e605ca34380ce25b2108db15254de03a806a4fa086b41211da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee230034d2865729b942200cdbf10fcc84c319ccc0f82e81b9698668d0264ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "573e15a0bfdadceb76379461a9886034eb6073cd696bcad86ed06633402f57d2"
    sha256 cellar: :any_skip_relocation, ventura:        "e556a55c957e25eb4ea3536c65bf41084832402a25695164682f3119b1f1ddcd"
    sha256 cellar: :any_skip_relocation, monterey:       "67eda2bf9e104706533218155cedf4e92a2355c77305bea3c0790be2e2fdea88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa66cbbfa24de6f1c3a6b0881e25c66346232180f7f5a36de41823b84058732e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
