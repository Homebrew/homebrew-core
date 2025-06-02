class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.17.0.tar.gz"
  sha256 "4e2a2cb516c9eca4d17d4b67033ac891daec22d2d18ac3068191d80be59d34fa"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8742c93896c82ee816d8ab71d4d589f8d121eca1466549390328e482eef0b9d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7da601a9b336ed010333037fc1669e544cce189ef51201219097fb6045af7c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "835260204f25a5b6149205b69b89af19a7fe27ebbcd2121c5f89748227e0db64"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a53c60b5aabb194be52c3d5ae7528f24dfeb01735177025bb98d050f7182722"
    sha256 cellar: :any_skip_relocation, ventura:       "cd7a447256ceffb0b888b5097c2f80fb01e61d4b3046aa8105cbddbe5460519e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d037e8c3d505b8658799a12ec436b6f3abc5b5ef69a530326057d5ca6d3698b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b158fb9f79ae4dfe2571cb8435cc817a6c5a8530b0d879efb531e180659941cd"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
