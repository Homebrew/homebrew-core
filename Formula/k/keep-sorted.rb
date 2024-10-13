class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8eee061af908fd971911118975e4a2870afff385b3aea9948cc9b221849a9436"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f3c6c8da17ff074bfeb1b8d269cfd57d2ae74136c9c87816b142947f78a615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f3c6c8da17ff074bfeb1b8d269cfd57d2ae74136c9c87816b142947f78a615"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f3c6c8da17ff074bfeb1b8d269cfd57d2ae74136c9c87816b142947f78a615"
    sha256 cellar: :any_skip_relocation, sonoma:        "3799f06dc1744cf5cfa11131ad06a9dd5a316f661a30bf2432ca1cc191862b6c"
    sha256 cellar: :any_skip_relocation, ventura:       "3799f06dc1744cf5cfa11131ad06a9dd5a316f661a30bf2432ca1cc191862b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a7e7b8e8e4c649347212f5d29bec81ea41f1ddd6c3cc4bc68b0538b51cdf8b"
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
