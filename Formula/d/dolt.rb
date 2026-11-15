class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "079d04427cb3df75ad40826d5402e7b4847187c4286844e0d6ee28d97446b87d"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e41b405e132d028c13c4fcb60e350e990ceed6d26f0abce179e0ead7db3c54da"
    sha256 cellar: :any, arm64_tahoe:       "e12ac5d1e1cb89ad8253e9c3c8fbc0f0e527eb5a6659919ee72841e60af5500f"
    sha256 cellar: :any, arm64_sequoia:     "53ba3e1192253dfd9d2c0e5fd32e81c871e46931a1c6c4a22364fefcbf3b4c98"
    sha256 cellar: :any, arm64_linux:       "aa85c2d997ea47a9a1a483fb3ae7dc515794c8c0c16ab3794cc5d9eaea778c85"
    sha256 cellar: :any, x86_64_linux:      "99dd485e47635fc670c1dfa85b6122e195be5620e33f3d96af09852c0b987341"
  end

  depends_on "go" => :build
  depends_on "icu4c@79"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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
