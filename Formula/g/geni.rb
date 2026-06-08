class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "df47a50e11c00c267f74dda72dc021c0d8040a6031e5a7f03e40f64148052c19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd61338d5a05345b6a68e9cdc001e4858f8b95114cd7288917fee64eee94b919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6258b9128b1b279c32bd9db744e59784b884b25429d25f66e83b51d7cf41e9e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d5f598c58849d8e92a11072841bf677a3976bcf0d78e7e9798363647885dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1499710310962b678215feb9daaf2b2df60a518f39a4d081840964d6452bb4b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4b289a38d4e6cff9b1b0cc4e4832acb285d3d694d79264910cacdc7dfe0305a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19f9a4850a54d81c8ca7667a4996cbf217ac7b61e4c5e7d8ccd04547b96f71c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
