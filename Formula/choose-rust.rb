class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.2.0.tar.gz"
  sha256 "5711a301e8cc7a5f257773feef992ce8da714a9ee167f234943203ee36c923ad"

  depends_on "rust" => :build

  conflicts_with "choose", :because => "both install a `choose` binary"
  conflicts_with "choose-gui", :because => "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
