class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.3.0.tar.gz"
  sha256 "62b03429855af3509282b32d654c49128072da5fc1ca2b795f1dadaf77e79539"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d461334505eed181cd92527d6b228d5fa96040c7808fa7ece8f88f5062e3381d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd11f309f002febecdbf34d44fb63193558460043a6f545a20a6730eadd3adf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36aa3e1921074f107a35f227b931ce6b99ea010cd5d49d0194aa45a60d31ae12"
    sha256 cellar: :any_skip_relocation, sonoma:        "3be80f61af2d2c190ed39663b2139bace751d7c5c0148a705247635d5f299a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa33262a4d128f9af93f2febee934a99edab521ed8e4148cda1a64926b0c4400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "228f28e59c2d1d3bed47132922733d0148e2a0311e905641c8ab63a771491197"
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
