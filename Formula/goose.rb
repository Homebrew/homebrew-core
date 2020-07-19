class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.6.0.tar.gz"
  sha256 "389953f40e567fd92090fd29d60e1baec576e6432e689f11ef54e6493502383a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c61983ec470b8ca810e5f4d084ed1c03518281290e0e0f873efd0a703fdd3657" => :catalina
    sha256 "121541b4371c54909eb3d0e3c20c99d60166ce4eab54521e6e8e2a42f0c4e71e" => :mojave
    sha256 "0e8c6ed483b244eac2370dad2d7fa59a6a7f1075305577553aac66463c7b0062" => :high_sierra
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
