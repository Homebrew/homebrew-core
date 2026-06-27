class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.3.2.tar.gz"
  sha256 "926e5ba85886178ec31cbc5ae7c8ba180395a6930e1b94d3ca285b38f3816898"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174c07c72c1165161d8c1380856c2a4a3d1837d4aa2a7a9191c08ef2718cd0b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31cb6f64ea0b38673da04a72c97f145776c012e819e7b87d47ff5a6f65bfc97d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51382f61b3879dfddd03b4bfbaf10fbc73483ea83a85e4dcd8e5afa3175acf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b11b63c1d53b9d98549748cc50e190eabecf035279b26bb0ffea21f2889f765"
    sha256 cellar: :any,                 arm64_linux:   "4cfe0aeb7f0b22f8a3b7d2069d81d66656d6fed16e1eaffbe1be8ebe665ddc43"
    sha256 cellar: :any,                 x86_64_linux:  "15e18f4634b6a2d8fc134b8d010e74633f85a37bca4753769957138cb147c83a"
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
