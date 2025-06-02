class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "eb15f4eef5d418ef002c388f1c30b5802cea3f30609185ce4d12ef05e5148711"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b454b956683fdb424faf9d899e9f27a319949ca30cc8629ec297bb86fd231db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b454b956683fdb424faf9d899e9f27a319949ca30cc8629ec297bb86fd231db3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b454b956683fdb424faf9d899e9f27a319949ca30cc8629ec297bb86fd231db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "427da10a6b21d60ee3df226cc974018fda3eedd6af251af383f27af80f5253d9"
    sha256 cellar: :any_skip_relocation, ventura:       "427da10a6b21d60ee3df226cc974018fda3eedd6af251af383f27af80f5253d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55039aa88fc295cffebda6c27d4a536fc605a4ab10c5ee1570967d0ae6de570c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
