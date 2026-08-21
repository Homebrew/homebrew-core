class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/d2lang/d2/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e2fb1fe1d7b76196ee01a3a244356e7f22f7d3c30922f8d6a8a193ac05737172"
  license "MPL-2.0"
  head "https://github.com/d2lang/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d3100ef95b35b2f4ee2fe2705f018fb5adaf69760ba13a06c696b7eb4cebdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57d3100ef95b35b2f4ee2fe2705f018fb5adaf69760ba13a06c696b7eb4cebdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d3100ef95b35b2f4ee2fe2705f018fb5adaf69760ba13a06c696b7eb4cebdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "871119c77baa85990ab8b8973f547fa8c5ca0ff9989423df5e41b761f22865c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b084a98f93f3273da808d68bb1ab20c3bae5b936e7c1541b4a4da2e6db6aeb"
    sha256 cellar: :any,                 x86_64_linux:  "a7203f69bcd53f2dba5c14e004a80e1cb1ed85c1b1e25666bfd480aeaec435e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_path_exists testpath/"test.svg"

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
