class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.4.0.tar.gz"
  sha256 "70b842f5495ea7e233308e97f82ea82db91287b54ad2eace749fa67737c74012"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0874aa31e9a29c7d5e3b7ed6bb7d0edf50fb6033eb2e1b2d5a66ef26b71f1f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3232e59b2d0c7709a0826f8dbb5fd40db230cf07162e6f3d57ebaf337c351445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc4a5c0448571ff91415f77350dae21bff9e7d04ea880b2e2d31f5eadbcf82d"
    sha256 cellar: :any_skip_relocation, sonoma:        "864071010353987c7f11127fd7f7ee2f92df99bc826b72884e99bfceae08c8c5"
    sha256 cellar: :any,                 arm64_linux:   "15a810295a79d2107db5915bbb2bae991963c178d12b99ab310d9ab4b1bf69e9"
    sha256 cellar: :any,                 x86_64_linux:  "78ff0092fcebd090fcad8225d4a2f80b4d3cdaee1fc14d3a8c8cb68e7d6450be"
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
