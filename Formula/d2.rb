class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ce658b1ed243b2712a7544f109f08dbc6f9690d1f6443a3fa6b39d0f6ccd626a"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51714993eab975c13adeea4aad668d8650718083b33b922f13aa93af65cf8e6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0aae7a8bd4616952be48935bc8d2a76df914d1c09285aa2ab9f50b3726283fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6079c806a5b6f2536c89715b5dcc17bd79113b48396e6bfec988dcd1d93de04e"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe649e7603093065c4be16c325298a2b8da52afc1fba9fafdfce51ff56d046e"
    sha256 cellar: :any_skip_relocation, monterey:       "984ef1bc1da77be4b35e0e6d83f04afc112b7305de0503dbf4ac0d5dd289c27d"
    sha256 cellar: :any_skip_relocation, big_sur:        "77380aaa9862c5ebc24b427cb89a5674fa2b887b7aadcec04cf3d78e08580ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84cc2528f6d8b63a44a01469d8751d78266e3211753ca20d9b52501d608cbd49"
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
