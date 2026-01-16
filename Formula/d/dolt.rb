class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.80.2.tar.gz"
  sha256 "11a77c1c154ea6e801eb3024885b644719e81858a216bbd9700500f193843e51"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57c06fc75ab095a838e26dfcc58250a73b021f29d6d587f2ae8d4c5d3bd6306c"
    sha256 cellar: :any,                 arm64_sequoia: "2a0901ec3f424531228fba8f618fa90e3acf776f72ac6b469409722806996213"
    sha256 cellar: :any,                 arm64_sonoma:  "e632862d6f2361459dc3d2c2be04fa605d6fc1b43e969a7e9c55de2c35e5dd67"
    sha256 cellar: :any,                 sonoma:        "f2cded5745766fd58855b304b2e2d1bfd1c3f4cd17af5da33ece4b226b633e12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41cb02f0ee4a6bb8b05c0fa39ef4f1fc3fba5aea0b72136941fdc1733e1a0709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b141472077f7edd1c6b38ae0378e6b4b5f1b30ba112941c4c0ede7ff122c11"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
