class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "93fdbacb3acb8d6cd0d752c18b785054a0091da06e0faaf59611646b9b4994e3"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c50b97275bdc234b1cf83ef253609ee6e6843c771141036e1c1574bcf76364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c85cbfee9e07f1ba6e7c7215f64c27eea939618e1d2f225871d9d2dfb532c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "467066a9a632bfcd4d05e9beadbc13d695d998ebecda9417c9a054add964bd5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bcc8fc5774dee12a10f86a9c2bc596160a16971fce5e13ae81b4fd2ac24d799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3979c3ae5bed0a90828ab2a1763236d0e302ce98e050a546936df401d8e0bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ae120beef85c07fd3d6bdd8295d194b156acf6c122c264a9415be1b51aa69b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
