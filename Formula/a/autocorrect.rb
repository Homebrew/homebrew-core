class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "0aef23b4a40e39759ccd6f5c073b36d87e228eb8790d677145e6adde38bc376d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1794166fb34512f180ebf9ed6ef4b55eac13fad9885943c41013d5299bda09b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6728180139bff31ada423bf4068956a17aab82e654a01f53cead9dd2dce61a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42c3b2bfbd5738a7762a729ae0b16b22aa15d559b9f6d98b66ac3c2322f84526"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e39386f4383798e8f0e7f81fc6c17034c769b9ad3afd8d39443cfd257866aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fed71303ceaa3272b6f141d60944c267ac12ab2e5670f91db198a1bd9835afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d00c53c780607dbcfc15dab89aeb3dace74d5264ab86c771d3a05ee80587b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
