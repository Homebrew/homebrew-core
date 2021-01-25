class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.7.0.tar.gz"
  sha256 "ce4115e3184d0929a90c5e4215d303aa5243e8d49f8576154396098f0c6536fd"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "87864462e22abc1dcf9b949c7b9b1106b0e4327fa5aabe94e514a29eeee66a10" => :big_sur
    sha256 "b9bfd06826a5bc66bcf6616632476c3535f26a9cd5d5955415db1f3b48e9100b" => :arm64_big_sur
    sha256 "3838102fe4c61d9dec9d5147f247e1856ec134ebe4a5eb07d12aacf99513a1d9" => :catalina
    sha256 "9b4be2cab4a2053e9142af56eeb15c3c91e8fd810f64a073dadf4911c4a59543" => :mojave
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
