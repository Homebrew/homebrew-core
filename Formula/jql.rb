class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.2.2.tar.gz"
  sha256 "4a593ea6b6c06ec78a9f3694f325fd0d64d218bd4cb3ee6e3ef892c0d88cc4eb"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d881a43aa6c1d8202d174225bcfab605d2862560199c7ceff3d43513f10b70b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eab968de30bb8efb8d0cc54aee659f54e6d8eda17921065a4a5c36d95848236"
    sha256 cellar: :any_skip_relocation, monterey:       "e9285337931112213c4144974746fa6bce4e5f1bee0960ab125032eeb3565c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b75d875e5add1db8a228a58f56b66e0a3a05c2d58dbcbbe7f56460ffe5d37e0e"
    sha256 cellar: :any_skip_relocation, catalina:       "31d38ccc5c349fcefc44810d6b2173928dcca4e418f51bf441935f808144fc78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27e6889a7ec075e8e4ac9c8c59e6de48caad6afe0475ce193297f76c558ab967"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
