class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.3.1.tar.gz"
  sha256 "cf9b749a5f723d6fb7a10b91b1444da514d670397ee9e115613a62c0b956b7e6"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e6bddacf1922908819e97b912530933762cc0ef309cd8c6ba96e25e601070d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c72344ba315d212bcaec3989873876b1fbf9ab1f372e6fff929264fea6fe7a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49212f796b9a0d713e642f2d4bfbfa93ae4f00f1df7595bc368c3d40568d5bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "650efaf6fab29452c127f2fd54fe58ffde603ba8d50cba1b3b0261913d9970e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "362457816c1d1e1bc22ec6d7b4ace678e7087de1a2e93a3187fee0e769ef37fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63df45f2e20e00b8e4a014e77b9dbeacb2410a5db5a728a9e239cd00b1a4d77"
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
