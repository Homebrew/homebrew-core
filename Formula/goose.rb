class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.1.0.tar.gz"
  sha256 "20b6ac732a7c061deafbda8cc8ca99b364c15e9514cf4129446de9d869eada61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5aa75ca4d971c2e468578e14420b24a871289821d97a16536281b0f7f36f7e80"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbf598f66668976ffe35a8e514b0cde29b03751f3b9485b2505f96023d332e23"
    sha256 cellar: :any_skip_relocation, catalina:      "36c391edd88b00a8eb66986c7ac53f394569543ba8dd81f69873c1832c9e41b3"
    sha256 cellar: :any_skip_relocation, mojave:        "ecb7254b46a8c0e1118f3d4f9a7a8316147b1900e108fc8022d8de51346cdcdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d0013a7acd1ab24e7ad38af1203e9de13f64e24976881d4be807f672b48249"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
