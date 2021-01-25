class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.2.0.tar.gz"
  sha256 "044a1c459b5255cce83bbfc0e8bc73ea227cf9c1c904fc3dada46f640136cbc5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "838e83415f9a81d03dbde62ddc086233979d5b52b279c0a1edbc6ef754099a4d" => :big_sur
    sha256 "dcc2f40817719ab6db214cf102ef282e7d5bd24fdb55b3a0f3e242bea28c3e9a" => :arm64_big_sur
    sha256 "ed5e5d307438bf853693618019f776d6907ae948fd06ae1f7317b6d886645895" => :catalina
    sha256 "d58d2bdb2a3a7f81f4ee78ac8dec5b71a1f0c2b6b89e83be8a921a74a263ac2d" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json")
    assert_equal output, expected
  end
end
