class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.7.0.tar.gz"
  sha256 "ce4115e3184d0929a90c5e4215d303aa5243e8d49f8576154396098f0c6536fd"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "906fbc0f90c83707d12893293874bd3b60c8861ee4f1e3ddb1a40b10476827d4" => :big_sur
    sha256 "c61983ec470b8ca810e5f4d084ed1c03518281290e0e0f873efd0a703fdd3657" => :catalina
    sha256 "121541b4371c54909eb3d0e3c20c99d60166ce4eab54521e6e8e2a42f0c4e71e" => :mojave
    sha256 "0e8c6ed483b244eac2370dad2d7fa59a6a7f1075305577553aac66463c7b0062" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # raise a quesiton about this setup, https://github.com/pressly/goose/issues/238
    mv "_go.mod", "go.mod"
    mv "_go.sum", "go.sum"

    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
