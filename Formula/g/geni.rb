class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "b157ff3c57b4c36e2f48f57da1b6dba60bf2f9770061e068e4302bc555df3b3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0c065f87c3ce64671c0f36eedd80e13d56a21c45c61ef755839dc96293531f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74820471f17b8a327cc05a8ac0c957444813ccf1be99b20d7b79a19e897851b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc895d5c2c04c5a6ba40767556167c4ebbb1a73a5defb296097ba6cd7c855f32"
    sha256 cellar: :any_skip_relocation, sonoma:        "c277e5900dfdda32af10c5dd0a2b45422edb08bd1c8c1d6c4eb5cfef0f61200b"
    sha256 cellar: :any_skip_relocation, ventura:       "7cf01e1ac2484893fe9a0db0b384fdddbd264fe3119863aba9a97f441615fb12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1d9d66d8c475c4070f96d8e2dfac2fd2f9876e698464599027f618a65733c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "902e107b2f2308354e3d97ffe130dcc5489cafee6c538f465bcc20a0677f8a76"
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
