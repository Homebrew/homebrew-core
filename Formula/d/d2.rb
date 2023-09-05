class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8409de84c1d47fd325bc6daf7d1f012ff483f6e873b14550881803e6f6a07f35"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8946aea84430479abc5a3de1a4e6f10ca0d99cab4e3f78c0926ca4a0c8d8834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8946aea84430479abc5a3de1a4e6f10ca0d99cab4e3f78c0926ca4a0c8d8834"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8946aea84430479abc5a3de1a4e6f10ca0d99cab4e3f78c0926ca4a0c8d8834"
    sha256 cellar: :any_skip_relocation, ventura:        "fcb20e95819792adfaef88b6feffdf2a682416c3dddc72be4b71b25a9cf07e25"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb20e95819792adfaef88b6feffdf2a682416c3dddc72be4b71b25a9cf07e25"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcb20e95819792adfaef88b6feffdf2a682416c3dddc72be4b71b25a9cf07e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25c8d136823322d336c09465f57ab22c5705bc7e5d228abd22601c66d3af233e"
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

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
