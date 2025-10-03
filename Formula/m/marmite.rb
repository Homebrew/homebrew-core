class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.2.6.tar.gz"
  sha256 "9fee0c1e8ec717690690fe05c4c9cf25c38d7bc6ad090d8a7abb5a6f1b947a00"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "721fa238cfe290857bec69a9c3a346e8a12c87eeb972f923a051c5418a0a69ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b930471e773b30aec68a5712ea885e1a77c8c663e8782f5a02ac6aafb531fb1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf78397f20834b0fc3092af64703eacdab9eaee8e802b15218e2891438541f34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a2504921ef8914c3391fd751bae8b6044f2aa9050ee55ad8d7593aa9c275bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "60c31e3c74626518a357788fa33c8be042e6b14235aff87bf7466ee21a482030"
    sha256 cellar: :any_skip_relocation, ventura:       "19b08685bda878b7d460e33a8e059760c2b8949fcd68668807264cf0ff30acf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4f5a3dcf61847992a7a3fddce171a176d60c87a7f3d48191dac454df02d73ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce1b9d9cac6c7f80ae332838a8e2a62b8929c1a882ddb77a7e6c868bef4258f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmite --version")

    system bin/"marmite", testpath/"site", "--init-site"
    assert_path_exists testpath/"site"
  end
end
