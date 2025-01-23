class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "28a8290da4908999712896ed0a94a0e26f290f22b565f290a0782220379a033c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "797e297714c252a065978c49a89f01ebfc6c1752e53e02471655259fe247d88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797e297714c252a065978c49a89f01ebfc6c1752e53e02471655259fe247d88e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "797e297714c252a065978c49a89f01ebfc6c1752e53e02471655259fe247d88e"
    sha256 cellar: :any_skip_relocation, sonoma:        "352cd36a00bd951afd2daa050b61e26152f45f8b6c6c1e10962b8647feb9d147"
    sha256 cellar: :any_skip_relocation, ventura:       "352cd36a00bd951afd2daa050b61e26152f45f8b6c6c1e10962b8647feb9d147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e54d534f58e5b89b4e4d80f0f621b736704de48121ae6ed599d059e037a64f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_file = testpath + "test_input"
    test_file.write <<~EOS
      line will not be touched.
      # keep-sorted start
      line 3
      line 1
      line 2
      # keep-sorted end
      line will also not be touched.
    EOS
    expected = <<~EOS
      line will not be touched.
      # keep-sorted start
      line 1
      line 2
      line 3
      # keep-sorted end
      line will also not be touched.
    EOS

    system bin/"keep-sorted", test_file
    assert_equal expected, test_file.read
  end
end
