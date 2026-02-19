class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.15.tar.gz"
  sha256 "91263404b12dc4fba29cee418d067b638eb78cac8dc5040a311c0dc5ef98b55d"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b8019156221382156ed613a77e9dae06620d7a4a2b067a4590289c2e92933bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b4159fd2d42b9ed2f63e31924f112c353510e1377ca85bc8fcade665a64d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c0e0d2fe2463ed36dd5be440e96ca4cd2a4dd93f66cf0d0ae7787987f437bed"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ae13eb0caf770a5f98e5f519806ddecde41f2fbc1607e51eadbcb438dca074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77692f97af4e8b2ec81481e5c056762b0fa29c866121c4c08c775e9c3b709b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7b776ecad98811b59fb0f64d8a106f1e34c9fd16890770bac2d221bd48b730b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
