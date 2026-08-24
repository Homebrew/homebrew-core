class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.4.2.tar.gz"
  sha256 "a32b5bc2e077a8e16eb92acc4408b1ebc7b68230ce5843aee6774298fe637cc2"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6d31d6436b9c14d1ff0d776066eb1e30e61023d530004567bc4cb38be2bf43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d8430843a7a51d92facac975d84e423824ff4d6dd226a40a55a016dfc2862ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fa41b08a724fb5d1d3b49b0af90d5518091023eb102bab050bdf2228dc5d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cf8c9758fd9db818c7a921cea92f2369ca6994f2cf881dbe3e982dad96587eb"
    sha256 cellar: :any,                 arm64_linux:   "2aced781724970ccc242f7bf6fe6653b2373ac6f476cf2831471d9f197eafcaf"
    sha256 cellar: :any,                 x86_64_linux:  "07efcf7b91c3d9bb20be976e1a231ff3dc7080f2dd27c79c7a8ffd722f9d16c3"
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
