class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.1.tar.gz"
  sha256 "5b399fe48672596d32f8165df3dee52bf794d24541f46e5e90dd8b73c5e10629"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436f6a25232ba348bf852408c0233d73165cda5d80cf2d1a2baf5a771582689f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3b13c0f73eb0d9f91d02294fae72884c036b69ebfe29731ef77852377c9e88c"
    sha256 cellar: :any_skip_relocation, monterey:       "851d8211ed481e232e69dedc00a2dc2c174489a7fd09be8dd3f1d383a7e56009"
    sha256 cellar: :any_skip_relocation, big_sur:        "458ad19530eb9d013b6316095767b39af6a4a9fb7ec67dc6c2811ffaf1e0e8a9"
    sha256 cellar: :any_skip_relocation, catalina:       "f7ea06162b6b6136dd4bb069c36d6f7c34b5c406d8c1c579cd4999025d3b526b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a7db0afc2d670d082bb6890d98d2cdfd8dba9cf52e49366f1b987412d3858b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
