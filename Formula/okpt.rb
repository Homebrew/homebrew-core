class Okpt < Formula
  desc "Healthcare ecosystem built for everyone"
  homepage "https://openkoppeltaal.nl"
  url "https://github.com/openkoppeltaal/homebrew-okpt/archive/refs/tags/0.0.1.tar.gz"
  sha256 "caad25a46eb99ee8e02fc73f99873e9036599d4bf940d1b9829f932078f00956"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "false"
  end
end
