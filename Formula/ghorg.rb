class Ghorg < Formula
  desc "Quickly clone an entire org/users repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "d0d1d9a18793f583cab838821d45c43ab41ab59f9105d6cb557bc4789b9b5374"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
