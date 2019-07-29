class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.3.0.tar.gz"
  sha256 "f19ec6ef1bae596e013a40c300d7f28ba91f71f6f7d6d0f13d03feaf4ab1ac43"

  bottle do
    cellar :any_skip_relocation
    sha256 "1143891d26f430acacc6b47128d0eaa520508925dc0f1d594685c997d77b5e38" => :mojave
    sha256 "c98cdc85daea46b8439109211194ede9342ff76c296f830f9225872c28877baa" => :high_sierra
    sha256 "a5c492e34e3351d3efb87b0e5f3e2571741e6efad35f794e3de64f39a8cd464f" => :sierra
    sha256 "720376f84dc67566d55a27325771ce36e5ed523f2d7eba20a0982022b37a3b85" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pressly/goose").install buildpath.children
    cd "src/github.com/pressly/goose" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"goose", ".../cmd/goose"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
